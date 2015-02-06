request    = require('co-supertest')
{ create } = require './server'
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

describe 'Initialization', (empty) ->
    it 'should return 404 when method is not post', ->*
        res = yield request.get('/').expect(404).end()
        expect(res.text).to.equal('sorry, only POST methods allowed')

    it 'should return an error when the request is not compliant with specs', ->*
        res = yield request.post('/').send({+foo}).expect(406).end()

    it 'should return a success when request is compliant', ->* 
        res = yield request.post '/'
        .send(packet(333, 'my answer', {+what}))
        .expect(200).end()