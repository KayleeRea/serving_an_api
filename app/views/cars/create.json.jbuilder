json._links do
  json.self do
    json.href car_path(@car)
 end
json.makes do
  json. href make_path(@car)
end
end
    json.id @car.id
    json.color @car.colors
    json.doors @car.doors
    json.purchased_on @car.purchased_on
