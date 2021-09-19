from random import choice, uniform, randint


CARGO_NAMES = ["Grain", "Coal", "Wood", "Mineral fertilizers", "Cement"]
CARGO_DB_KEYS = [(i + 1) for i in range(len(CARGO_NAMES))]
FREIGHT_CARS_NUMBER = 10000


def get_json_text():
    text = '['
    for ind in range(len(CARGO_NAMES)):
        text += get_cargo_json_description(ind)
        text += ', '
    for ind in range(FREIGHT_CARS_NUMBER):
        text += get_freight_car_json_description()
        last_freight_car_ind = FREIGHT_CARS_NUMBER - 1
        if ind < last_freight_car_ind:
            text += ', '
    text += ']'
    return text


def get_cargo_json_description(cargo_ind):
    descr = \
        '{\n' \
        '   "model": "Database.Cargo",\n' \
        f'   "pk": {CARGO_DB_KEYS[cargo_ind]},\n' \
        '   "fields": {\n' \
        f'       "name": "{CARGO_NAMES[cargo_ind]}"\n' \
        '   }\n' \
        '}'
    return descr


def get_freight_car_json_description():
    def get_random_cargo_db_key():
        return choice(CARGO_DB_KEYS)

    def get_random_cargo_amount():
        min_amount, max_amount = 57.0, 90.0
        return uniform(min_amount, max_amount)

    def get_random_day_number():
        min_day_number, max_day_number = 1, 30
        return randint(min_day_number, max_day_number)

    descr = \
        '{\n' \
        '   "model": "Database.FreightCar",\n' \
        '   "fields": {\n' \
        f'      "cargo": {get_random_cargo_db_key()},\n' \
        f'      "cargo_amount": {get_random_cargo_amount()},\n' \
        f'      "day_number": {get_random_day_number()}\n' \
        '   }\n' \
        '}'
    return descr


if __name__ == "__main__":
    with open("generated_data.json", "w") as f:
        f.write(get_json_text())
