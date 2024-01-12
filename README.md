
## AirtelTracker
AirtelTracker is shell script for accessing data bundle balances for your 4G router plan into Home Assistant. 
The script is then called from a `command_line` sensor in Home Assitant which periocally runs on a scan interval.  
The balance is then exposed for use in dashboarding and graphing in Home Assistant
<img align="right" source="![image](https://github.com/Protocol789/homeassistant/assets/44654683/10d06fb2-a1fe-40a1-a566-e282af098ee3)"/>


### Quickstart
Run the bootstrap script which will download the latest release for you 
```sh 
wget https://raw.githubusercontent.com/Protocol789/homeassistant/main/bootstrap/bootstrap.sh -O- | sh
```
### Requirements
- Home Assistant
- SSH access
- Access to edit Home Assistant confguration.yaml file

### Prerequisates 
* Required
    * Home Assitant
    * Your airtel web username and password used to login to [Airtel](https://airtel.co.zm/broadband/#/user/login) broadband portal
* Optional (Recommended)
    * Home Assistant Add-ons
    * [File editor](https://my.home-assistant.io/redirect/supervisor_addon/?addon=core_configurator)
    * [Advanced SSH & Web Terminal](https://my.home-assistant.io/redirect/supervisor_addon/?addon=a0d7b954_ssh)

### Usage 
In these installation steps, the Addons in prerequistates are used however you can use whatver you are most comfortable with

1. Jump into a terminal session on the Home Assitant instance and move into the /config directory via `cd config/` 
2. Run the bootstrap script which will download the latest release for you 
```sh 
cd config/
wget https://raw.githubusercontent.com/Protocol789/homeassistant/main/bootstrap/bootstrap.sh -O- | sh
```
3. Time to test!  
   Get the Airtel credentials and plug them into the script where `$username` and `$password` are your Airtel credentials respectively  
  
   Command to run  
   `./Airtel_GetBalance.sh $username $password -V`  
   Response
   ```sh
   2024-01-12 01:12:33 - INFO ---- Running airtel login call
   2024-01-12 01:12:33 - INFO ---- -------------------------
   2024-01-12 01:12:35 - INFO ---- Login: HTTP response of 200 OK!
   2024-01-12 01:12:35 - INFO ---- Extracted login token
   2024-01-12 01:12:35 - INFO ---- -------------------------
   2024-01-12 01:12:35 - INFO ---- Starting Airtel Balance call
   2024-01-12 01:12:36 - INFO ---- Get Balance HTTP response of 200 OK!
   2024-01-12 01:12:36 - INFO ---- Here's your balances per bundle
   {"balance":"8.45","unit":"GB","message":"success","status":"SUCCESS","statusCode":200}
   ```
  4. Now its time to edit the `configuration.yaml` to add the entity.
     Head over to File Editor Addon or open the file in your favoruite text editor
  5. Place the following yaml into the file and ensure your update the `$username` and `$pasword`  
       * The `scan_interval` is set to 30 minutes but can be set to any value you need (in seconds)  
       * The entity `name` can be whatever you like
     
     Save the file  
     ```yaml
     command_line:
       - sensor:
           name: Airtel
           scan_interval: 1800      
           command: sh /config/airtel/Airtel_GetBalance.sh $username $password
           value_template: "{{ value_json.status }}"
           json_attributes:
             - message
             - statusCode
             - balance
             - unit
 
     ```
      ![image](https://github.com/Protocol789/homeassistant/assets/44654683/cd6ea0f7-536c-4294-91bd-2c2b150919ea)

  7. Now restart Home Assstant
     This can be done directly from File Editor  
     ![image](https://github.com/Protocol789/homeassistant/assets/44654683/7e1fd33f-0f9b-4258-8a89-28ffd553f28a)

 
  8. Once restarted head over to (Developer Tools States)[https://my.home-assistant.io/redirect/developer_states/] and filter for your new entity
     Note the json attributes now show the total data balance avaliable on your Airtel bundle! 👏 
     ![image](https://github.com/Protocol789/homeassistant/assets/44654683/78f4ed18-cf03-4838-8652-f4b043816e32)
  9. It's now time to expose the data bundle balance via a (helper entity)[https://my.home-assistant.io/redirect/helpers/] which will reference the attribute and allow you to add it to a dashboard
      Click Create Helper in bottom right corner
  10. Click `Template`  
![image](https://github.com/Protocol789/homeassistant/assets/44654683/b45a653d-d400-48fc-b97b-d6c6eb0bcdb1)
  11. Select `Template a sensor`  
![image](https://github.com/Protocol789/homeassistant/assets/44654683/f6fd64ca-dac3-40f9-9044-b33289a7b3dd)
  12. New sensor details  
        
      Fill in a name for the new sensor
         
      The `state template` will be refercing the new entitiy we created in the configuration.yml and extracting the `balance` attribute out  
      `` {{ state_attr( 'sensor.airtel_new' , 'balance' ) }} ``
        
      Select the unit of mesasurement, device class and State class and click `Submit`  
      ![image](https://github.com/Protocol789/homeassistant/assets/44654683/5e44fb54-6e6b-4e30-8559-6669dabc0966)
  13. Add the new sensor to a dashboard of your choosing!
  14. ![image](https://github.com/Protocol789/homeassistant/assets/44654683/da959880-cbb5-43d1-80de-d2358bb9be1e)


### Config
TODO
### Debugging
The base script can be run with a few arguments for logging verbosity.
* `-s` Silent (Default mode)

  The default mode which the script runs in. Only returns the json response success or failure information.  
  This repsonse is parased by the command_line processor in Home Assitant and exposed into the entity  
  * Replace `$WebUsername` and `$WebPassword` with your Airtel credentials used to login to the website
  
  *Run command*
  ```sh
    ./Airtel_GetBalance.sh $WebUsername $WebPassword 
  ```
  Response
  ```sh
  root@zorab-surface:~/Airtel# ./Airtel_GetBalance.sh $WebUsername $WebPassword
  {"balance":"8.46", "unit":"GB", "message":"success", "status":"SUCCESS", "statusCode":200}
  ```

* `-V` Informational

  <details><summary><b>Show informational example</b></summary>

  ```sh
    ./Airtel_GetBalance.sh $WebUsername $WebPassword -V
  ```
  
  ```sh
  root@pc:~/Airtel# ./Airtel_GetBalance.sh $WebUsername $WebPassword -V
  2024-01-12 00:37:54 - INFO ---- Running airtel login call
  2024-01-12 00:37:54 - INFO ---- -------------------------
  2024-01-12 00:37:56 - INFO ---- Login: HTTP response of 200 OK!
  2024-01-12 00:37:56 - INFO ---- Extracted login token
  2024-01-12 00:37:56 - INFO ---- -------------------------
  2024-01-12 00:37:56 - INFO ---- Starting Airtel Balance call
  2024-01-12 00:37:57 - INFO ---- Get Balance HTTP response of 200 OK!
  2024-01-12 00:37:57 - INFO ---- Here's your balances per bundle
  {"balance":"8.46", "unit":"GB", "message":"success", "status":"SUCCESS", "statusCode":200}
  ```

  </details>

* `-G` Debug
  <details><summary><b>Show debug example</b></summary>

  Replace `$WebUsername` and `$WebPassword` with your Airtel credentials used to login to the website
  ```sh
    ./Airtel_GetBalance.sh $WebUsername $WebPassword -G
  ```
  ```sh
  root@pc:~/Airtel# ./Airtel_GetBalance.sh $WebUsername $WebPassword -G
  2024-01-12 00:35:12 - DEBUG --- -G specified: Debug mode
  2024-01-12 00:35:12 - DEBUG --- Variable passed in postion 1: $username
  2024-01-12 00:35:12 - DEBUG --- Variable passed in postion 2: $password
  2024-01-12 00:35:12 - DEBUG --- Running payload creator
  2024-01-12 00:35:12 - DEBUG --- This is login payload:
  {"username":"$username","password":"$password"}
  2024-01-12 00:35:13 - INFO ---- Running airtel login call
  2024-01-12 00:35:13 - INFO ---- -------------------------
  2024-01-12 00:35:15 - DEBUG --- Login: HTTP code response 200
  2024-01-12 00:35:15 - INFO ---- Login: HTTP response of 200 OK!
  2024-01-12 00:35:15 - DEBUG --- Login: Body reponse is:
  ```

  </details>
  


