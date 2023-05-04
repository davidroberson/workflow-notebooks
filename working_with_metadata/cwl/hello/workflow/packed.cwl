{
    "class": "CommandLineTool",
    "baseCommand": "touch",
    "inputs": [
        {
            "type": "string",
            "default": "Hello.txt",
            "inputBinding": {
                "position": 1
            },
            "id": "#main/message"
        }
    ],
    "id": "#main",
    "outputs": [
        {
            "type": "File",
            "outputBinding": {
                "glob": "*.txt"
            },
            "id": "#main/blar"
        }
    ],
    "cwlVersion": "v1.2"
}