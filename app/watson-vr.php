<pre>
<?php
    echo date('l F d, Y G:i:s');

    $watson_json_env = getenv('WATSON_VR');
    $watson_json_decoded = json_decode($watson_json_env,true);
    $url=$watson_json_decoded["url"]."/v3/classify?api_key=".$watson_json_decoded["api_key"]."&url=https://raw.githubusercontent.com/phssakaigawa/tsukiji-container/master/app/sushi-1958247_640.jpg&version=2016-05-17";
    $ch = curl_init($url);
    echo("---------");
    
    curl_setopt($ch,CURLOPT_HEADER,0);
    
    $response=curl_exec($ch);
    $info=curl_getinfo($ch);
    curl_close($ch);
    
    var_dump($response);

?>
</pre>
