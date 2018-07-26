BASEURL = "https://demo.securityknowledgeframework.org/api/chatbot"
GITTER_PREFIX = 'GITTER'
CONTEXT = {}

module.exports = (robot) ->
    robot.hear /(.*)/i, (res) ->
        ## Get the input
        ques = res.match[1];
        user_id = res.message.user.id
        #console.log("UserID", user_id)

        ## check if some context exists
        if CONTEXT["#{GITTER_PREFIX}" +user_id]
            #console.log("m inside")
            sol(res, robot, CONTEXT["#{GITTER_PREFIX}"+ user_id][ques], user_id);

            return

        sol(res, robot, ques, user_id);

sol = (res, robot, ques, user_id)->
    robot.http("https://demo.securityknowledgeframework.org/api/chatbot/question","rejectUnauthorized": false)
          .header('Content-Type', 'application/json')
          .header('Accept', 'application/json')
          .post(JSON.stringify({"question": "#{ques}", "question_option": 0, "question_lang": "string"})) (err, response, body) ->
                if err
                    res.send "Encountered an error :( #{err}"
                    return

                data = JSON.parse(body);
                result = []
                for i of data.options
                    counter = data.options[i];
                    result.push "#{counter.answer}";

                if result.length ==1
                    delete CONTEXT["#{GITTER_PREFIX}"+ user_id];
                    res.send "#{result}";
                else
                    for i,value in result
                        CONTEXT["#{GITTER_PREFIX}" +user_id] = result
                        #console.log(CONTEXT["#{GITTER_PREFIX}" +user_id]);
                        res.send "#{value}"+" "+"#{i}";

                    ## user_id, save the context for this person
                    #CONTEXT["#{GITTER_PREFIX}" +user_id] = result
                    #console.log(CONTEXT[GITTER_PREFIX])
                    # robot.hear /(.*)/i, (res) ->
                    #     optn = res.match[1];
                    #     sol(res,robot,result[optn]);
