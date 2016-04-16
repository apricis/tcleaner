NIMFLAGS = --app:console --stackTrace:on --lineTrace:on
NIM = nim

tcleaner: tcleaner.nim
	$(NIM) c $(NIMFLAGS) tcleaner.nim
