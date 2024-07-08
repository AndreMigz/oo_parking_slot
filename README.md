# OO Parking Slot (Backend) 🚗

## Environment 🚧
- This backend api requires to have the ruby on rails envionment installed on your local machine. If its not you could follow the installation instructions here. [Ruby on rails installation guide]()
- System requirement:
  - Ruby: version `3.3.0`
  - Rails: version `7.1.3.x`
  - Postgres: `14.11` or higher

## Getting Started ⚙️

- Clone the repository by running the following on your terminal.

  ```bash
  git clone https://github.com/AndreMigz/oo_parking_slot.git
  cd wherezit
  ```
- Install dependencies

  ```bash
  bundle install # Installs the gems needed
  ```
- Setup Database

  ```bash
  rails db:prepare

  # OR run each step manually

  rails db:create # Creates database
  rails db:migrate # Creates the database schema
  rails db:seed # Adds initial data 
  ```
- Run server 🚀
  ```bash
  rails server
  ```
  - On Development environment the default base_url is `localhost:3000` or `http://127.0.0.1:3000`

## Testing Endpoints 🧪
- The API includes of endpoints that can be tested using postman.
  - **Park a vehicle** 
    - This assigns vehicles to parking slots by considering the closest slot to their entry point and ensuring the slot is appropriate for the vehicle's size.
    - Endpoint: `/park`
    - Method: `POST `
    - Request body:
      ```json
      {
        "vehicle_id": "your_vehicle_id",
        "entry_point_id": "your_entry_point_id"
      }
      ```
    - Sample Response:
      ```json
      {
        "status": "success",
        "status_code": 201,
        "parking_session": {
            "id": 8,
            "vehicle_id": 2,
            "parking_slot_id": 8,
            "entry_time": "2024-07-08T00:29:01.590Z"
        },
        "assigned_slot": {
            "id": 8,
            "name": "C2",
            "occupied": true
          }
       }
      ```
  - **Unpark vehicle**
    - In the system, this process unparks the vehicle, freeing the assigned parking slot, and calculates the parking fee based on the slot size and the duration of the parking.
    - Endpoint: `/unpark`
    - Method: `POST `
    - Request body:
      ```json
      {
        "session_id": "your_parking_session_id"
      }
      ```
    - Sample Response:
      ```json
      {
          "vehicle": {
              "id": 3,
              "size": "large",
              "created_at": "2024-07-07T05:14:09.122Z",
              "updated_at": "2024-07-07T05:14:09.122Z"
          },
          "parking_fee": 1640
      }
      ```
  - **Entry point list**
    - Gets the list of available entry points to the parking lot.
    - Endpoint: `/entry_points`
    - Method: `GET`
    - Sample Response:
      ```json
      {
        "entry_points": [
          {
              "id": 1,
              "name": "A",
              "created_at": "2024-07-07T05:14:09.042Z",
              "updated_at": "2024-07-07T05:14:09.042Z"
          },
          {
              "id": 2,
              "name": "B",
              "created_at": "2024-07-07T05:14:09.065Z",
              "updated_at": "2024-07-07T05:14:09.065Z"
          }
        ]
      }
      ```
  - **Create entry**
    - This creates a new entry point.
    - Endpoint: `/entry_points`
    - Method: `POST`
    - Request Body:
      ```json
      {
        "entry_point":
        {
          "name": "New Entry point"
        }
      }
      ```
  - **Get Vehicle list**
    - This gets the list of vehicles.
    - Endpoint: `/vehicles`
    - Method: `GET`
    - Sample Response:
      ```json
      {
        "vehicles": [
          {
            "id": 1,
            "size": "small",
            "created_at": "2024-07-07T05:14:09.104Z",
            "updated_at": "2024-07-07T05:14:09.104Z"
          },
          {
            "id": 2,
            "size": "medium",
            "created_at": "2024-07-07T05:14:09.113Z",
            "updated_at": "2024-07-07T05:14:09.113Z"
          }
        ]
      }
      ```
  - **Create vehicle**
    - This creates a new vehicle.
    - Endpoint: `/vehicles`
    - Method: `POST`
    - Request Body:
      ```json
      {
        "vehicle":
        {
          // This accepts 3 values (small, medium, large)
          "size": "small"
        }
      }
      ```