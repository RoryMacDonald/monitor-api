require 'sinatra'
require 'json'
require 'cgi'
$stdout.sync = true

def random_payment
  rand(999999999)
end

def project_id
  rand(99999)
end

get '/pcs-api/v1/Projects/:bid_id' do
  bid_id = CGI.unescape(CGI.unescape(params['bid_id']))
  puts "PCS project data requested for #{bid_id}"

  content_type 'application/json'
  response.body = {
    projectManager: "Ken Thompson",
    sponsor: "Dennis Ritchie"
  }.to_json
  200
end

get '/pcs-api/v1/Projects/:bid_id/actuals' do
  project_id = rand(99999)
  bid_id = CGI.unescape(CGI.unescape(params['bid_id']))
  puts "PCS project actuals data requested for #{bid_id}"

  content_type 'application/json'
  response.body = [
    {
      bidIdentifier: bid_id,
      projectIdentifier: project_id,
      dateInfo: {
        period: "2018/19",
        monthNumber: 11
      },
      phase: {
        name: "Capital Grant (CDEL)",
        number: 1
      },
      expense: {
        code: 162,
        description: "Capital contribution to local authority"
      },
      previousYearPaymentsToDate: random_payment,
      payments: {
        currentYearPayments: [
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment
        ]
      }
    },
    {
      bidIdentifier: bid_id,
      projectIdentifier: project_id,
      dateInfo: {
        period: "2018/19",
        monthNumber: 11
      },
      phase: {
        name: "Resource Grant (RDEL)",
        number: 2
      },
      expense: {
        code: 396,
        description: "Revenue contribution to local authority"
      },
      previousYearPaymentsToDate: random_payment,
      payments: {
        currentYearPayments: [
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment,
          random_payment
        ]
      }
    }
  ].to_json
  200
end
