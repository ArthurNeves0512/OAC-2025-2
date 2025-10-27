import subprocess
import numpy as np
import os
import re

# --- CONFIGURAÇÃO ---
RARS_JAR_PATH = os.path.join('LAB1', 'Arquivos', 'Rars16_Custom1.jar')
ASSEMBLY_TEMPLATE = os.path.join('LAB1', 'Q3-DFT-template.asm')
ASSEMBLY_INSTANCE = 'temp_dft_instance.asm'
EPSILON = 1e-4

# --- DEFINIÇÃO DOS CASOS DE TESTE DO RELATÓRIO ---
# Cada chave é um nome de teste e o valor é o sinal de entrada x[n].
REPORT_TEST_CASES = {
    # --- Item 3.4 do Relatório ---
    "Item 3.4 - x1 (Impulso N=8)":
        np.array([1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]),
    "Item 3.4 - x2 (Sinal de Cosseno N=8)": 
        np.array([1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071, 0.0, 0.7071]),
    "Item 3.4 - x3 (Sinal de Seno N=8)": 
        np.array([0.0, 0.7071, 1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071]),
    "Item 3.4 - x4 (Degrau Parcial N=8)":
        np.array([1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]),
        
    # --- Item 3.5 do Relatório ---
    "Item 3.5a (N=8)": np.pad([1.0, 1.0, 1.0], (0, 5)),
    "Item 3.5b (N=12)": np.pad([1.0, 1.0, 1.0], (0, 9)),
    "Item 3.5c (N=16)": np.pad([1.0, 1.0, 1.0], (0, 13)),
    "Item 3.5d (N=20)": np.pad([1.0, 1.0, 1.0], (0, 17)),
    "Item 3.5e (N=24)": np.pad([1.0, 1.0, 1.0], (0, 21)),
    "Item 3.5f (N=28)": np.pad([1.0, 1.0, 1.0], (0, 25)),
    "Item 3.5g (N=32)": np.pad([1.0, 1.0, 1.0], (0, 29)),
    "Item 3.5h (N=36)": np.pad([1.0, 1.0, 1.0], (0, 33)),
    "Item 3.5i (N=40)": np.pad([1.0, 1.0, 1.0], (0, 37)),
    "Item 3.5j (N=44)": np.pad([1.0, 1.0, 1.0], (0, 41)),
}

def generate_asm_file(signal_x):
    n_points = len(signal_x)
    x_data = ", ".join([f"{val:.6f}" for val in signal_x])
    data_section = f"""
two_pi: .float 6.2831853
N: .word {n_points}
x: .float {x_data}
X_real: .space {n_points * 4}
X_imag: .space {n_points * 4}
msg_header:    .ascii "x[n]      X[k]\\n"
               .byte 0
msg_separator: .ascii "      "
               .byte 0
msg_plus:      .ascii "+"
               .byte 0
msg_i_newline: .ascii "i\\n"
               .byte 0
msg_performance_header:    .ascii "\\n--- Performance Metrics ---\\nInstructions: "
                           .byte 0
msg_performance_separator: .ascii " | Time: "
                           .byte 0
msg_performance_ms:        .ascii " ms\\n"
                           .byte 0
\n
"""
    with open(ASSEMBLY_TEMPLATE, 'r', encoding='utf-8') as f:
        template_content = f.read()
    instance_content = template_content.replace("##DATA_SECTION##", data_section)
    with open(ASSEMBLY_INSTANCE, 'w', encoding='utf-8') as f:
        f.write(instance_content)

def parse_rars_output(output_str):
    """Interpreta a saída completa: DFT, tempo e instruções."""
    dft_results = []
    instructions = None
    exec_time = None
    
    # Parse da tabela DFT
    dft_line_pattern = re.compile(r"^\s*[\d\.\-e]+\s+.*[ij]\s*$", re.IGNORECASE | re.MULTILINE)
    for line in dft_line_pattern.findall(output_str):
        parts = re.split(r'\s+', line.strip())
        complex_str_part = "".join(parts[1:]).lower().replace("i", "").replace("j", "")
        sep_index = -1
        for i in range(len(complex_str_part) - 1, 0, -1):
            if complex_str_part[i] in ['+', '-'] and complex_str_part[i-1] != 'e':
                sep_index = i
                break
        if sep_index == -1: continue
        real_part = float(complex_str_part[:sep_index])
        imag_part = float(complex_str_part[sep_index:])
        dft_results.append(np.complex128(complex(real_part, imag_part)))
        
    # Parse das métricas de desempenho
    perf_match = re.search(r"Instructions:\s*(\d+)\s*\|\s*Time:\s*(\d+)\s*ms", output_str)
    if perf_match:
        instructions = int(perf_match.group(1))
        exec_time = int(perf_match.group(2))
        
    return np.array(dft_results), instructions, exec_time

def run_report_generator():
    """Executa todos os testes do relatório e imprime os resultados formatados."""
    print("=" * 80)
    print("--- GERADOR DE RELATÓRIO PARA A QUESTÃO 3 - DFT EM ASSEMBLY RISC-V ---")
    print("=" * 80)
    
    if not os.path.exists(ASSEMBLY_TEMPLATE):
        print(f"\nERRO CRÍTICO: Arquivo gabarito '{ASSEMBLY_TEMPLATE}' não encontrado.")
        return

    for name, signal in REPORT_TEST_CASES.items():
        print(f"\n\n--- EXECUTANDO: {name} ---")
        
        # Gera e executa o código Assembly
        generate_asm_file(signal)
        command = ['java', '-jar', os.path.abspath(RARS_JAR_PATH), os.path.abspath(ASSEMBLY_INSTANCE)]
        result = subprocess.run(command, capture_output=True, text=True, encoding='utf-8')
        
        # Calcula o resultado esperado
        expected_dft = np.fft.fft(signal)
        
        # Interpreta a saída do Assembly
        obtained_dft, instructions, exec_time = parse_rars_output(result.stdout)
        
        # Imprime o relatório para este caso de teste
        print(f"Sinal de Entrada x[n] (N={len(signal)}):")
        print(np.array2string(signal, precision=4, separator=', '))
        
        print("\nResultado Esperado (NumPy):")
        print(np.array2string(expected_dft, precision=4, separator=', ', sign=' '))

        print("\nResultado Obtido (Assembly RISC-V):")
        if obtained_dft.size > 0:
            print(np.array2string(obtained_dft, precision=4, separator=', ', sign=' '))
        else:
            print("ERRO: Não foi possível interpretar a saída da DFT.")

        # Validação
        if obtained_dft.shape == expected_dft.shape and np.allclose(expected_dft, obtained_dft, atol=EPSILON):
            print("\n[VALIDAÇÃO: SUCESSO] O resultado do Assembly está correto.")
        else:
            print("\n[VALIDAÇÃO: FALHA] O resultado do Assembly está incorreto.")

        print("\n--- Métricas de Desempenho (Item 3.5.1) ---")
        if instructions is not None and exec_time is not None:
            print(f"Número de Instruções (I): {instructions}")
            print(f"Tempo de Execução (texec): {exec_time} ms")
            # Calcula a frequência conforme o relatório: f = I / t_exec (em segundos)
            if exec_time > 0:
                frequency_hz = instructions / (exec_time / 1000.0)
                print(f"Frequência do Processador Simulado: {frequency_hz / 1e6:.4f} MHz")
            else:
                print("Frequência do Processador Simulado: N/A (tempo de execução foi 0 ms)")
        else:
            print("ERRO: Não foi possível interpretar as métricas de desempenho.")
        
    # Limpeza
    if os.path.exists(ASSEMBLY_INSTANCE):
        os.remove(ASSEMBLY_INSTANCE)
        
    print("\n" + "=" * 80)
    print("--- GERAÇÃO DO RELATÓRIO CONCLUÍDA ---")
    print("=" * 80)

if __name__ == '__main__':
    run_report_generator()