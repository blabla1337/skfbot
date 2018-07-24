
module.exports = (robot) ->
   robot.hear /(.*)/i, (res) ->
     ques = res.match[1]
     #res.send "#{ques}"
     #rootCas = require('ssl-root-cas/latest').create();

     #require('https').globalAgent.options.ca = rootCas;
     robot.http("https://demo.securityknowledgeframework.org/api/chatbot/question","rejectUnauthorized": false)
          .header('Content-Type', 'application/json')
          .header('Accept', 'application/json')
          .post(JSON.stringify({"question": "#{ques}", "question_option": 0, "question_lang": "string"})) (err, response, body) ->
               if err
                  res.send "Encountered an error :( #{err}"
                  return
               #res.send "#{body}"
               data=JSON.parse(body);
               for i of  data.options
                   counter = data.options[i];
                   #res.send "#{counter.length}";
                   #if counter.length==1
                   res.send "#{counter.answer}";
                   #else
                    #  res.send "#{i} #{counter.answer}";

              
