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
                "id" => ford_car.id,
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
                "id" => chevy_car.id,
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

  describe 'GET /cars/:id' do
    it 'returns a specific cars info' do

      ford = create_make(name: "Ford")

      ford_car = create_car(colors: "red", doors: 4, purchased_on: "1973-10-04", make_id: ford.id)

      get "/cars/#{ford_car.id}", {}, {'Accept' => 'application/json'}

      expected = {
        "_links" => {
          "self" => {
            "href" => car_path(ford_car)
          },
          "makes" => {
            "href" => make_path(ford)
          }
        },
        "id" => ford_car.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
      }

      expect(response.code.to_i).to eq(200)
      expect(JSON.parse(response.body)).to eq(expected)
    end

    it 'returns a 404 if the car can not be found' do
      get "/cars/1000", {}, {'Accept' => 'application/json'}


      expect(response.code.to_i).to eq(404)
      expect(JSON.parse(response.body)).to eq({})
    end
  end

  describe 'POST /cars' do
    it 'posts the car that was created to /cars' do


      ford = create_make(name: "Ford")

      posted_data = {
        "make_id" => ford.id,
        "colors" => 'blue',
        "doors" => 2,
        "purchased_on" => "2012-01-24"
      }.to_json

      expect { post '/cars', posted_data, 'Accept' => 'application/json' }.to change { Car.count }.by(1)

      created_ford = Car.last

      expected = {
        "_links" => {
          "self" => {
            "href" => car_path(created_ford)
          },
          "makes" => {
            "href" => make_path(created_ford)
          }
        },
        "id" => created_ford.id,
        "color" => "blue",
        "doors" => 2,
        "purchased_on" => "2012-01-24"
      }


      expect(response.code.to_i).to eq(201)
      expect(JSON.parse(response.body)).to eq(expected)
    end
  end
end
