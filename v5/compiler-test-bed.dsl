Part CompilerTestBed
[retract-fact prolog-factbase-string-stream finished-pipeline request-in done-step]
[fb step error]
[
  reader [in-stream] [string-fact eof error]
  convert-to-keywords [string-fact eof] [converted done error]
  fb [retract lisp-fact iterate get-nest show reset fb-request] [fb next no-more error]
  sequencer [finished-reading prolog-output-filename finished-writing finished-pipeline] [show write-to-filename run-pipeline write error]
  writer [filename start next no-more] [request error]
]

self.reset -> fb.reset
self.add-fact -> fb.lisp-fact
self.retract-fact -> fb.retract
self.prolog-factbase-string-stream -> reader.in-stream
self.prolog-ouput-filename -> sequencer.prolog-output-filename
self.finished-pipeline -> sequencer.finished-pipeline
self.done-step -> self.step

reader.error -> self.error
reader.eof -> convert-to-keywords.eof
reader.string-fact -> convert-to-keywords.string-fact

convert-to-keywords.converted -> fb.lisp-fact
convert-to-keywords.done -> sequencer.finished-reading
convert-to-keywords.error -> self.error

fb.fb -> self.fb
fb.next -> writer.next
fb.no-more -> sequencer.finished-writing, writer.no-more
fb.error -> self.error

sequencer.show -> fb.show
sequencer.write-to-filename ->writer.filename
sequencer.run-pipeline -> self.step
sequencer.write -> writer.start, fb.iterate
sequencer.error -> self.error

writer.request -> fb.get-next
writer.error -> self.error
