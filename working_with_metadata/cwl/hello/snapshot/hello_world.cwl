cwlVersion: v1.2

class: CommandLineTool
# This CommandLineTool executes the linux "echo" command-line tool.
baseCommand: touch

# The inputs for this process.
inputs:
  message:
    type: string
    # A default value that can be overridden, e.g. --message "Hola mundo"
    default: "Hello.txt"
    # Bind this message value as an argument to "echo".
    inputBinding:
      position: 1

outputs:
  blar:
    type: File
    outputBinding:
      glob: '*.txt'