$statusCode = wget http://stackoverflow.com | % {$_.StatusCode}
if ($statusCode -eq "200") {
  echo "Website ok"
  } else {
  echo "Website not ok"
  }
