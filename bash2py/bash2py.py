#!/usr/bin/python3
import sys
import re

def do_files():
    for file in sys.argv[1:]:
        try:
            with open(file, 'r') as f:
                for line in f:
                    print(process_line(line), end='')
        except FileNotFoundError:
            print(f'{sys.argv[0]}: error reading file {file}', file=sys.stderr)
            exit(1)
        
        

def process_line(line):
    if re.fullmatch(r'#!\/.+\s', line):
        return '#!/usr/bin/env python3\n'

    elif re.fullmatch(r'\s*(while|if) \(\((.+)\)\)\s', line): #while or if statements 
        match = re.fullmatch(r'(\s*)(while|if) \(\((.+)\)\)\s', line)
        return f'{match.group(1)}{match.group(2)} {match.group(3)}:\n'

    elif re.fullmatch(r'\s*(.+)=\$\(\((.+)\)\)\s', line): #var assign with arithmetic 
        match = re.fullmatch(r'(\s*)(.+)=\$\(\((.+)\)\)\s', line)
        string = f'{match.group(1)}{match.group(2)} = {match.group(3)}\n'
        return re.sub(r'\/', '//', string)

    elif re.fullmatch(r'\s*.+=\$?.+\s', line):
        match = re.fullmatch(r'(\s*)(.+)=\$?(.+)\s', line) #normal var assignment
        return f'{match.group(1)}{match.group(2)} = {match.group(3)}\n'

    elif re.fullmatch(r'(\s*)(fi|done|do|then)\s', line): #delete bash key words not used in python
        return ''
    
    elif re.fullmatch(r'(\s*)(else)\s', line):
        match = re.fullmatch(r'(\s*)(else)\s', line)
        return f'{match.group(1)}{match.group(2)}:\n'
    
    elif re.fullmatch(r'\s*(echo|printf) (.+)\s', line):
        if(re.fullmatch(r'\s*echo (\$.+)\s', line)):
            match = re.fullmatch(r'(\s*)echo (\$.+)\s', line)
            string = re.sub('\$','',match.group(2).strip())
            string = re.sub(' ', ', ',string)
            return f'{match.group(1)}print({string})\n'
        elif(re.fullmatch(r'(\s*)(echo|printf) (\"?.+\"?)\s', line)):
            match = re.fullmatch(r'(\s*)(echo|printf) (\"?.+\"?)\s', line)
            string = re.sub('\"|\'','',match.group(3))
            return f'{match.group(1)}print("{string}")\n'

    return line



def main(): 
    if len(sys.argv) > 1:
        do_files()
    else:
    
        for line in sys.stdin:
            print(process_line(line), end='')
    


if __name__ == '__main__':
    main()
