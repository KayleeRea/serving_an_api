require 'rails_helper'

describe 'Make an API' do

  describe 'GET /cars' do
    it 'returns a list of cars' do

      ford = create_make(name: "Ford")
      chevy = create_make(name: "Chevy")

      ford_car = create_car(colors: "red", doors: 4, purchased_on: "1973-10-04", make_id: ford.id)
      chevy_car = create_car(colors: "blue", doors: 2, purchased_on: "2012-01-24", make_id: chevy.id)

      get '/cars', {}, {'Accept' => 'application/json'}

      expected_response =
        {
          "_links" => {
            "self" => {
              "href" => "/cars"
            }
          },
          "_embedded" => {
            "cars" => [
              {
                "_links" => {
                  "self" => {
                    "href" => car_path(ford_car)
                  },
                  "makes" => {
                    "href" => make_path(ford)
                  }
                },
                "id" =>ford.id,
                "color" => "red",
                "doors" => 4,
                "purchased_on" => "1973-10-04"
              },
              {
                "_links" => {
                  "self" => {
                    "href" => car_path(chevy_car)
                  },
                  "makes" => {
                    "href" => make_path(chevy)
                  }
                },
                "id" => chevy.id,
                "color" => "blue",
                "doors" => 2,
                "purchased_on" => "2012-01-24"
              }
            ]
          }
        }

      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq(expected_response)
    end
  end
end