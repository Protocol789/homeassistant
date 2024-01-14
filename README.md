
# AirtelTracker

AirtelTracker is shell based script for accessing data bundle balances for your data plan from the Airtel mobile carrier.

Home Assistant calls the script periodically to retrieve the data values.

The data bundle balance is then exposed for use in dashboard and graphing in Home Assistant via a sensor entity🍾  

<img  height="150" src="https://raw.githubusercontent.com/Protocol789/homeassistant/main/.github/balance.png" alt="Data balance" />     <img  height="150" src="https://raw.githubusercontent.com/Protocol789/homeassistant/main/.github/gauge.png" alt="Home Assistant data gauge" /> <img height="150" src="https://raw.githubusercontent.com/Protocol789/homeassistant/main/.github/card.png" alt="Home Assistant entity card"/>

## QuickStart

Open your fav *nix terminal  

1. Run the bootstrap script

  ```sh
  wget -q https://raw.githubusercontent.com/Protocol789/homeassistant/main/bootstrap/bootstrap.sh -O- | sh
  ```

2. Run the Get balance command below with your Airtel web credentials in place of the $variables below

  ```sh
  AirtelTracker/Airtel_GetBalance.sh $username $password -V
  ```

3. Data balances returned in JSON packet  
  ![image](https://github.com/Protocol789/homeassistant/assets/44654683/25e30bd1-73c2-4be6-b6da-81e6e542e8cc)

### Requirements

- Home Assistant
- SSH access
- Access to edit Home Assistant configuration.yaml file  
- Internet access from Home Assistant

### Prerequisites

- Required
  - Home Assistant
  - Your airtel web username and password used to login to [Airtel](https://airtel.co.zm/broadband/#/user/login) broadband portal

- Optional (Recommended)
  - Home Assistant Add-ons
    - [File editor](https://my.home-assistant.io/redirect/supervisor_addon/?addon=core_configurator)
    - [Advanced SSH & Web Terminal](https://my.home-assistant.io/redirect/supervisor_addon/?addon=a0d7b954_ssh)

### Usage

In these installation steps, the optional prerequisites are used however you can use whatever you are most comfortable with.

1. Jump into a [terminal](https://my.home-assistant.io/redirect/supervisor_addon/?addon=a0d7b954_ssh ) (click open web gui) session on the Home Assistant instance and move into the `/config` directory via

  ```sh
  cd config/
  ```

2. Run the bootstrap command which will download the latest release for you

```sh
wget -q https://raw.githubusercontent.com/Protocol789/homeassistant/main/bootstrap/bootstrap.sh -O- | sh
```

3. Time to test!  
Get the Airtel credentials and plug them into the script below where `$username` and `$password` are your Airtel credentials respectively  
  
Command to run  
`AirtelTracker/Airtel_GetBalance.sh $username $password -V`  

#### Response

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

4. Now its time to add the sensor entity into Home Assistant so that the JSON packet can be consumed and eventually visualized.  

    Open up the `configuration.yaml` in [File editor](https://my.home-assistant.io/redirect/supervisor_addon/?addon=core_configurator) (click open web gui) or open the file in your favourite text editor
  
5. Copy the following yaml snippet into Home Assistant's `configuration.yaml` file     <a id="step-6"></a>

   > [!IMPORTANT]
   > Ensure your update the `$username` and `$password` values  

- The `scan_interval` is set to 30 minutes but can be set to any value you need (in seconds)  
- The entity `name` can be whatever you like
   Save the file  

   ```yaml
   command_line:
     - sensor:
         name: Airtel
         scan_interval: 1800      
         command: sh /config/AirtelTracker/Airtel_GetBalance.sh $username $password
         value_template: "{{ value_json.status }}"
         json_attributes:
           - message
           - statusCode
           - balance
           - unit
   ```

<!-- 
![image](https://github.com/Protocol789/homeassistant/assets/44654683/cd6ea0f7-536c-4294-91bd-2c2b150919ea)
-->  
   <details>
      <Summary>Example config</Summary>
      <img src="https://raw.githubusercontent.com/Protocol789/homeassistant/readme-images/.github/config-yaml-snippet.png" width="200" alt="Example config.yaml snippet"/>  
   </details>  

6. Now do a FULL restart Home Assistant instance so the new configuration file and entity is loaded up  

    This can be done directly from File Editor Addon  

<!--
![image](https://github.com/Protocol789/homeassistant/asse44654683/7e1fd33f-0f9b-4258-8a89-28ffd553f28a)
-->  
  <img src="https://raw.githubusercontent.com/Protocol7homeassistant/readme-images/.github/images/ha-fileeditor-restart.png" alt="File Editor restart Home Assistant"/>

7. Once restarted head over to [Developer Tools States](https://my.home-assistant.io/redirect/developer_states/) and filter for your new entity.  
    
    Note the json attributes now show the total data balance available on your Airtel bundle! 👏
    ![image](https://github.com/Protocol789/homeassistant/assets/44654683/78f4ed18-cf03-4838-8652-f4b043816e32)  

8. It's now time to expose the data bundle balance via a [helper entity](https://my.home-assistant.io/redirect/helpers/) which will reference the attribute and allow you to add it to a dashboard  
    Click Create Helper in bottom right corner

9. Click `Template`  
![image](https://github.com/Protocol789/homeassistant/assets/44654683/b45a653d-d400-48fc-b97b-d6c6eb0bcdb1)

10. Select `Template a sensor`  
![image](https://github.com/Protocol789/homeassistant/assets/44654683/f6fd64ca-dac3-40f9-9044-b33289a7b3dd)

11. New helper template sensor details

    > [!IMPORTANT]
    > Ensure you reference the name of the sensor you created in [step 6](#step-6) by replacing the `sensor.SensorName`

    The `state template` will be referencing the new entity we created in the configuration.yml and extracting the `balance` attribute out  

    ` {{ state_attr( 'sensor.SensorName' , 'balance' ) }} `

    Select the unit of measurement, device class and state class and click `SUBMIT` buttom  

    <img src="https://raw.githubusercontent.com/Protocol789/homeassistant/readme-images/.github/images/ha-sensor-details.png"  width="200" alt="template sensor details"/> 
  <!-- ![image](https://github.com/Protocol789/homeassistant/assets/44654683/5e44fb54-6e6b-4e30-8559-6669dabc0966)-->

12. Add the new sensor to a dashboard of your choosing!  

13. Example of entity history 
<img src="https://raw.githubusercontent.com/Protocol789/homeassistant/readme-images/.github/images/ha-entitiy-balance.png"  width="300" alt="HA entity card popp with history"/> 
<!-- ![image](https://github.com/Protocol789/homeassistant/assets/44654683/da959880-cbb5-43d1-80de-d2358bb9be1e) -->

### Config

TODO

### Debugging

The base script can be run with a few arguments for logging verbosity.

- `-s` Silent (Default mode)

  The default mode which the script runs in. Only returns the json response success or failure information.  
  This response is parsed by the command_line processor in Home Assistant and exposed into the entity  
  - Replace `$WebUsername` and `$WebPassword` with your Airtel credentials used to login to the website
  
#### Run command

  ```sh
    ./Airtel_GetBalance.sh $WebUsername $WebPassword 
  ```

  Response

  ```sh
  root@zorab-surface:~/Airtel# ./Airtel_GetBalance.sh $WebUsername $WebPassword
  {"balance":"8.46", "unit":"GB", "message":"success", "status":"SUCCESS", "statusCode":200}
  ```

- `-V` Informational

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

- `-G` Debug
  <details>
    <summary>
     <b>Show debug example</b>
    </summary>

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
  
### Compatibility

The scripts were tested on following systems however any *nix system should work  

- Ubuntu 22.04.2 LTS (WSL)
- Home Assistant Operating System (2024)  
  <img src="https://raw.githubusercontent.com/Protocol789/homeassistant/readme-images/.github/images/ha-version.png"  width="400" alt="Home Assistant version screen"/>  

    <!-- ![image](https://github.com/Protocol789/homeassistant/assets/44654683/0e5a9973-0c7b-42b6-a1d2-eb812e8a306c) --> 
