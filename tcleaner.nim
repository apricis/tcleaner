import nre, parseopt2, streams, strutils, typetraits

let PUNCTUATION_RE: Regex = re"(\x22|…|–|—| - |”|“|„|«|»|§|[,._\[\]:\)\(/\\;\!\?\=]+|[-]{2,})"

let FORMATTING_RE: Regex = re"((\xcc\x81)||||■|©|•|®|%|[\^\*]+)"

let NUMBERS_RE: Regex = re"[0-9]+"

let SPACES_RE: Regex = re"[ ]+"

const helptext: string = """
tcleaner - clean raw text from special characters
Usage: tcleaner [-h] [-fp] [-fn] [-l] [-cp] [-f] < file > outfile

Options:
-h     Show this help text
-fp    Filter out all punctuation
-fn    Filter out all numbers
-l     Convert to lowercase
-cp    Correct paragraphs
-f     Filter formatting
"""

proc writeHelp() =
    stderr.write(helptext)


proc cleanText(input: Stream, filterPunctuation: bool, filterNumbers: bool, 
    lowerCase: bool, correctParagraphs: bool, filterFormatting: bool) =
    var
        line = ""

    if not isNil(input):
        while input.readLine(line):
            if filterPunctuation:
                line = line.replace(PUNCTUATION_RE, "")
            if filterNumbers:
                line = line.replace(NUMBERS_RE, "")
            if filterFormatting:
                line = line.replace(FORMATTING_RE, "")
            line = line.replace(SPACES_RE, " ")
            if correctParagraphs and line != "":
                stdout.write(" " & line)
            else:
                echo(line)
        input.close()


when isMainModule:
    var
        run: bool = true
        filterPunctuation: bool = false
        filterNumbers: bool = false
        lowerCase: bool = false
        correctParagraphs: bool = false
        filterFormatting: bool = false
    for kind, key, val in getopt():
        case kind
        of cmdLongOption, cmdShortOption:
            case key
            of "help", "h":
                writeHelp()
                run = false
            of "filter-punctuation", "fp":
                filterPunctuation = true
            of "filter-numbers", "fn":
                filterNumbers = true
            of "lowercase", "l":
                lowerCase = true
            of "correct-paragraphs", "cp":
                correctParagraphs = true
            of "filter-formatting", "f":
                filterFormatting = true
            else:
                discard
        else:
            discard

    if run:
        cleanText(newFileStream(stdin), filterPunctuation, filterNumbers, lowerCase, 
            correctParagraphs, filterFormatting)
        