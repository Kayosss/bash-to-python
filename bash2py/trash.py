#!/usr/bin/env python3

import re
import sys


def main():
    for (line_number, line) in enumerate(sys.stdin):
        line = line.rstrip()
        if line_number == 0 and line.startswith("#!"):
            print("#!/usr/bin/env python3")
        else:
            translate_line(line)


def translate_line(shell):
    # remove and save leading white space
    indent = re.match(r"\s*", shell).group(0)
    shell = shell[len(indent) :]

    # remove and save any comment & trailing white space
    comment = re.search(r"\s*(#.*)?$", shell).group(0)
    shell = shell[: -len(comment) or None]

    python = translate_command(shell)

    if python is not None:
        print(indent + python + comment)


def translate_command(command):
    command = translate_expression(command)
    if command in ["do", "done", "fi", "then"]:
        return None
    if m := re.match(r"(if|while|else)", command):
        return command + ":"
    if m := re.match(r"echo\s+(.*)", command):
        arguments = m.group(1)
        arguments = re.sub(r"\s+", ", ", arguments)
        return f"print({arguments})"
    if m := re.match(r"(.*?)=(.*)", command):
        return f"{m.group(1)} = {m.group(2)}"
    return ""


def translate_expression(expression):
    expression = expression.replace('$', '')
    expression = expression.replace("))", '')
    expression = expression.replace("((", '')
    expression = expression.replace("/", "//")
    return expression


if __name__ == "__main__":
    main()