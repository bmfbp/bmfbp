              :self[:start] -> dumper[:start],tokenize[:start]
              dumper[:request], strings[:request], ws[:reqest], symbols[:request] -> tokenize[:pull]
              tokenize[:out] -> strings[:token]
              strings[:out] -> parens[:token]
              parens[:out] -> spaces[:token]
              spaces[:out] -> symbols[:token]
              symbols[:out] -> dumper[:in]
              dumper[:out] -> :self[:out]
              
              dumper[:error], tokenize[:error], parens[:error], strings[:error], ws[:error], symbols[:error], spaces[:error] -> :self[:error]



              :self.:start -> dumper.:start,tokenize.:start
              dumper.:request, strings.:request, ws.:reqest, symbols.:request -> tokenize.:pull
              tokenize.:out -> strings.:token
              strings.:out -> parens.:token
              parens.:out -> spaces.:token
              spaces.:out -> symbols.:token
              symbols.:out -> dumper.:in
              dumper.:out -> :self.:out

              dumper.:error, tokenize.:error, parens.:error, strings.:error, ws.:error, symbols.:error, spaces.:error -> :self.:error

              self.start -> dumper.start,tokenize.start
              dumper.request, strings.request, ws.reqest, symbols.request -> tokenize.pull
              tokenize.out -> strings.token
              strings.out -> parens.token
              parens.out -> spaces.token
              spaces.out -> symbols.token
              symbols.out -> dumper.in
              dumper.out -> self.out

              dumper.error, tokenize.error, parens.error, strings.error, ws.error, symbols.error, spaces.error -> self.error


              self/start -> dumper/start,tokenize/start
              dumper/request, strings/request, ws/reqest, symbols/request -> tokenize/pull
              tokenize/out -> strings/token
              strings/out -> parens/token
              parens/out -> spaces/token
              spaces/out -> symbols/token
              symbols/out -> dumper/in
              dumper/out -> self/out

              dumper/error, tokenize/error, parens/error, strings/error, ws/error, symbols/error, spaces/error -> self/error


              self!start -> dumper!start,tokenize!start
              dumper!request, strings!request, ws!reqest, symbols!request -> tokenize!pull
              tokenize!out -> strings!token
              strings!out -> parens!token
              parens!out -> spaces!token
              spaces!out -> symbols!token
              symbols!out -> dumper!in
              dumper!out -> self!out

              dumper!error, tokenize!error, parens!error, strings!error, ws!error, symbols!error, spaces!error -> self!error

