request    = require('co-supertest')
{ create } = require('./server')
expect     = require('chai').expect;
b64        = require('base64-url')

app = create!

request = request.agent(app.listen())

$ = -> JSON.stringify(it(), 0, 4)

packet = (student-id, response, payload) ->

            xqueue_body: $ ->

                    student_info: $ -> 
                        { anonymized_id: student-id }

                    student_response: response  

                    grader_payload: $ ->
                            payload:
                                b64.encode $ -> payload


configure-server-dependencies = ->
    { configure } = require('./das')
    configure({
            'fs': 'fs' 
            'shelljs': 'shelljs'
            'os': 'os'
            'uid': 'uid'
    })   

configure-server-dependencies!

fake-test-payload = {
    lang: 'fakelang'
    base: "original-text"
    solution: "original-solution"
    validation: "assert(x==1);"
    context: null
}

fake-test-payload-fail = {
    lang: 'fakelang'
    base: "original-text"
    solution: "original-solution"
    validation: "bombit"
    context: null
}

rq = -> request.post('/').send(it).set('Accept', 'application/json').expect('Content-Type', /json/).expect(200).end!

rqfail = -> request.post('/').send(it).set('Accept', 'application/json').expect('Content-Type', /json/).expect(406).end!

describe 'Basic request/response protocol', (empty) ->
    it 'should return 404 when method is not post', ->*
        res = yield request.get('/').expect(404).end()
        expect(res.text).to.equal('sorry, only POST methods allowed')

    it 'should return an error when the request is not compliant with specs', ->*
        res = yield request.post('/').send({+foo}).expect(406).end()

describe 'Compliant requests', (empty) ->
    it 'should succeed when fake program works', ->* 
        res = yield rq(packet(333, 'var x = 1;', fake-test-payload))
        expect(res.body.correct).to.equal(true)

    it 'should fail when fake program bombs', ->* 
        res = yield rq(packet(333, 'var x = 1;', fake-test-payload-fail))
        expect(res.body.correct).to.equal(false)
        expect(res.body.msg).to.equal("noo! it failed")

    it 'should not run a program without a language id', ->*
        res = yield rqfail(packet(333, 'var x=1; console.log(x);', { validation: "" }))




describe 'Javascript execution', (empty) ->

    o = (program, validation, correct, msg, desc) ->
        actions = ->*
            res = yield rq(packet(333, program, { lang: 'javascript', validation: validation }))
            expect(res.body.msg).to.equal(msg)
            expect(res.body.correct).to.equal(correct)
        if correct
            return { desc: "when: #desc -> it should work", actions }
        else
            return { desc: "when: #desc -> it should not work", actions }

    js-tests = [
        o 'var x=1; console.log(x);' , ''                                         , true  , "ok! output: 1\n"      , 'working program , empty validation'
        o 'var x=1; console.log(x);' , undefined                                  , true  , "ok! output: 1\n"      , 'working program , undefined validation'
        o 'var x=1; console.log(x);' , 'return 0'                                 , true  , "ok! output: 1\n"      , 'working program , safe validation'
        o 'var x=1; console.log(x);' , 'process.exit(0)'                          , true  , "ok! output: 1\n"      , 'working program , safe validation'
        o 'var x=1; console.log(x);' , 'process.exit(2)'                          , false , "no! output: Error: 2" , 'working program , returns error'
        o 'var x=1; console.log(x);' , "require('assert')(x==1); process.exit(0)" , true  , "ok! output: 1\n"      , 'working program , validation succ'
        o 'var x=1; console.log(x);' , "require('assert')(x==2); process.exit(0)" , false , "no! output: Error: 1" , 'working program , validation fails'
        ]

    for t in js-tests
        it t.desc, t.actions



