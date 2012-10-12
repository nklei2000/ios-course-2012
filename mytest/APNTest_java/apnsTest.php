<?php 
   $apnsHost = 'gateway.sandbox.push.apple.com';

   $apnsCert = 'whatsfeeling_development.pem';
   $passphrase = 'whatsfeeling';
   $apnsPort = 2195;

   $streamContext = stream_context_create(); 
   stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
   stream_context_set_option($streamContext, 'ssl', 'passphrase', $passphrase);  
 
   $apns = stream_socket_client('ssl://' . $apnsHost . ':' . $apnsPort, $error, $errorString, 2, STREAM_CLIENT_CONNECT, $streamContext);
   $payload['aps'] = array('alert' => 'this is test!', 'badge' => 1, 'sound' => 'default');
   $output = json_encode($payload);
   // $mywifeToken = '8a07c5988008568172c6dfeffdc333d7ada28ec703bb0e0e955b0da1c1261191';
   $token = '1a2adff7163c960a1f4737ddc2174db9148ab41211bce7eaa8d2715b9b9398fc';
   $token = pack('H*', str_replace(' ', '', $token)); 
   $apnsMessage = chr(0) . chr(0) . chr(32) . $token . chr(0) . chr(strlen($output)) . $output;
   
   $result = @fwrite($apns, $apnsMessage, strlen($apnsMessage));

   // @socket_close($apns);
   fclose($apns);
   $apns = NULL;

?>
