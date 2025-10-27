import subprocess
import numpy as np
import os
import re

# --- CONFIGURAÇÃO ---
RARS_JAR_PATH = os.path.join('LAB1', 'Arquivos', 'Rars16_Custom1.jar')
ASSEMBLY_TEMPLATE = 'LAB1/Q3-DFT-template.asm' # Usar / para compatibilidade
ASSEMBLY_INSTANCE = 'temp_dft_instance.asm'
EPSILON = 1e-4 
ENERGY_EPSILON = 1e-5

# --- CASOS DE TESTE (ESCOPO EXAUSTIVO) ---
# (O restante dos casos de teste permanece o mesmo)
# Vetores x_a e x_b para o teste de linearidade
x_a = np.array([1.0, 2.0, -1.0, -2.0])
x_b = np.array([0.0, 1.0, 2.0, 3.0])

TEST_CASES = {
    # == Testes Fundamentais ==
    "Impulso Simples (N=4)": 
        np.array([1.0, 0.0, 0.0, 0.0]),
    "Sinal DC (N=4)": 
        np.array([1.0, 1.0, 1.0, 1.0]),
        
    # == Testes do Relatório (Item 3.4) ==
    "Relatório x1 (Impulso N=8)":
        np.array([1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]),
    "Relatório x2 (Sinal de Cosseno N=8)": 
        np.array([1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071, 0.0, 0.7071]),
    "Relatório x3 (Sinal de Seno N=8)": 
        np.array([0.0, 0.7071, 1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071]),
    "Relatório x4 (Degrau Parcial N=8)":
        np.array([1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]),
        
    # == Testes de Propriedades Matemáticas ==
    "Propriedade da Linearidade (N=4)":
        2.5 * x_a - 1.5 * x_b, # DFT(a*x+b*y) = a*DFT(x)+b*DFT(y)
    "Propriedade do Deslocamento no Tempo (N=8)":
        np.array([0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]),

    # == Casos Extremos e Gerais ==
    "Sinal Nulo (N=8)": # Testa a precisão do 0.0
        np.array([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]),
    "Sinal Alternado (Nyquist, N=4)": # Testa alta frequência
        np.array([1.0, -1.0, 1.0, -1.0]),
    "Sinal com N não-potência de 2 (N=6)": # Testa generalidade do algoritmo
        np.array([1.0, 2.0, 3.0, 0.0, 0.0, 0.0]),
}

def generate_asm_file(signal_x):
    n_points = len(signal_x)
    x_data = ", ".join([f"{val:.6f}" for val in signal_x])
    data_section =data_section = f"""
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
    template_path = os.path.join('LAB1', 'Q3-DFT-template.asm')
    
    # --- CORREÇÃO DE ENCODING APLICADA AQUI ---
    with open(template_path, 'r', encoding='utf-8') as f:
        template_content = f.read()
    # -------------------------------------------
        
    instance_content = template_content.replace("##DATA_SECTION##", data_section)
    
    with open(ASSEMBLY_INSTANCE, 'w', encoding='utf-8') as f:
        f.write(instance_content)

def parse_rars_output(output_str):
    # (O restante do código permanece exatamente o mesmo)
    results = []
    line_pattern = re.compile(r"^\s*[\d\.\-e]+\s+.*[ij]\s*$", re.IGNORECASE | re.MULTILINE)
    
    for line in line_pattern.findall(output_str):
        parts = re.split(r'\s+', line.strip())
        complex_str_part = "".join(parts[1:]).lower().replace("i", "").replace("j", "")

        sep_index = -1
        for i in range(len(complex_str_part) - 1, 0, -1):
            if complex_str_part[i] in ['+', '-']:
                if complex_str_part[i-1] != 'e':
                    sep_index = i
                    break
        
        if sep_index == -1 and ('e' in complex_str_part or (complex_str_part.count('-') + complex_str_part.count('+')) > 1):
             raise ValueError(f"Não foi possível encontrar o separador +/- em '{complex_str_part}'")
        elif sep_index == -1: # Caso seja um número real puro
            real_part = float(complex_str_part)
            imag_part = 0.0
        else:
            real_part_str = complex_str_part[:sep_index]
            imag_part_str = complex_str_part[sep_index:]
            real_part = float(real_part_str)
            imag_part = float(imag_part_str)
        
        results.append(np.complex128(complex(real_part, imag_part)))
            
    return np.array(results)

def run_test(test_name, signal_x):
    print(f"[*] Testando: {test_name}")
    generate_asm_file(signal_x)
    command = ['java', '-jar', os.path.abspath(RARS_JAR_PATH), os.path.abspath(ASSEMBLY_INSTANCE)]
    result = subprocess.run(command, capture_output=True, text=True, encoding='utf-8')
    
    if result.stderr:
        print(f"  [AVISO] - O RARS reportou uma mensagem de erro (stderr):\n{result.stderr}")

    expected_dft = np.fft.fft(signal_x)
    
    try:
        obtained_dft = parse_rars_output(result.stdout)
        if obtained_dft.shape != expected_dft.shape:
            raise ValueError(f"Tamanho do vetor de saída incorreto. Esperado {len(expected_dft)}, obtido {len(obtained_dft)}")
    except Exception as e:
        print(f"  [FAIL] - Falha ao interpretar a saída do RARS: {e}")
        print(f"--- SAÍDA DO RARS ---\n{result.stdout}\n--------------------")
        return False

    # Teste 1: Comparação direta dos valores
    dft_pass = np.allclose(expected_dft, obtained_dft, atol=EPSILON)
    if dft_pass:
        print("  [PASS] - Os valores da DFT correspondem ao esperado.")
    else:
        print("  [FAIL] - Os valores da DFT divergem do esperado.")
        print(f"    -> ESPERADO (NumPy): \n{expected_dft}")
        print(f"    -> OBTIDO (Assembly): \n{obtained_dft}")
        print(f"    -> DIFERENÇA (abs): \n{np.abs(expected_dft - obtained_dft)}")
        return False

    # Teste 2: Verificação de Conservação de Energia (Teorema de Parseval)
    energy_time = np.sum(np.abs(signal_x)**2)
    energy_freq = (1 / len(signal_x)) * np.sum(np.abs(obtained_dft)**2)
    
    energy_pass = np.isclose(energy_time, energy_freq, atol=ENERGY_EPSILON)
    if energy_pass:
        print("  [PASS] - O Teorema de Parseval (Conservação de Energia) foi verificado.")
    else:
        print("  [FAIL] - Falha na verificação do Teorema de Parseval.")
        print(f"    -> Energia no Tempo: {energy_time:.6f}")
        print(f"    -> Energia na Frequência: {energy_freq:.6f}")
        return False

    return True

def main():
    print("--- Iniciando Rotina de Testes Exaustivos para o Programa DFT em Assembly ---")
    
    template_path = os.path.join('LAB1', 'Q3-DFT-template.asm')
    if not os.path.exists(template_path):
        print(f"\nERRO CRÍTICO: Arquivo gabarito '{template_path}' não encontrado.")
        return

    passed_count = 0
    total_count = len(TEST_CASES)
    
    for name, signal in TEST_CASES.items():
        print("-" * 60)
        if run_test(name, signal):
            passed_count += 1
            
    if os.path.exists(ASSEMBLY_INSTANCE):
        os.remove(ASSEMBLY_INSTANCE)
        
    print("\n" + "=" * 60)
    print("--- Relatório Final da Rotina de Testes ---")
    print(f"Testes Executados: {total_count}")
    print(f"Testes Aprovados:  {passed_count}")
    print(f"Testes Reprovados: {total_count - passed_count}")
    print("=" * 60)

if __name__ == '__main__':
    main()