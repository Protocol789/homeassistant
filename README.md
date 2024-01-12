
## AirtelTracker
AirtelTracker is shell script for accessing data bundle balances for your 4G router plan into Home Assistant. 
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
    * Your airtel web username and password used to login to [Airtel](https://airtel.co.zm/broadband/#/user/login) broadband portal
* Optional (Recommended)
    * Home Assistant Add-ons
    * [File editor](https://my.home-assistant.io/redirect/supervisor_addon/?addon=core_configurator)
    * [Advanced SSH & Web Terminal](https://my.home-assistant.io/redirect/supervisor_addon/?addon=a0d7b954_ssh)

### Usage 
In these instalaltion steps, the Addons in prerequistates are used however you can use whatver you are most comfortable with

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




### Config

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
  


