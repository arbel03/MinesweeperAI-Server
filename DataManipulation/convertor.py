with open('parsed_data.txt', 'w') as out:
    with open('input_data.txt', 'r') as f:
        output_strings = []
        for l in f.readlines():
            out_l = ''
            colect = eval(l)
            target = colect[1]
            mat = colect[0]
            out_l = '{['
            for vec in mat:
                out_l += ' '.join([str(i) for i in vec]) + ' '
            out_l += '], ' + str(target) + '}'

            if not out_l in output_strings:
                output_strings.append(out_l)
    
    print [int(s[-2]) for s in output_strings]
    out.write('\n'.join(sorted(output_strings, key=lambda s: int(s[-2]))))