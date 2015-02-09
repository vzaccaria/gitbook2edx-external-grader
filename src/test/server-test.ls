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



test-payload = {
    lang: 'fakelang'
    base: "original-text"
    solution: "original-solution"
    validation: "assert(x==1);"
    context: null
}

test-payload-fail = {
    lang: 'fakelang'
    base: "original-text"
    solution: "original-solution"
    validation: "bombit"
    context: null
}

describe 'Initialization', (empty) ->
    it 'should return 404 when method is not post', ->*
        res = yield request.get('/').expect(404).end()
        expect(res.text).to.equal('sorry, only POST methods allowed')

    it 'should return an error when the request is not compliant with specs', ->*
        res = yield request.post('/').send({+foo}).expect(406).end()

    it 'should return a success when request is compliant', ->* 
        res = yield request.post '/'
        .send(packet(333, 'var x = 1;', test-payload))
        .expect(200).end()
        val = JSON.parse(res.text)
        expect(val.correct).to.equal(true)

    it 'should return a fail when program fails', ->* 
        res = yield request.post '/'
        .send(packet(333, 'var x = 1;', test-payload-fail))
        .expect(200).end()
        val = JSON.parse(res.text)
        expect(val.msg).to.equal("noo! it failed")