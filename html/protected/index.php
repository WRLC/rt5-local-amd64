<html>
 <body>
  <table>
<?php
    foreach ($_SERVER as $key => $value) {
        echo "   <tr><td>".htmlspecialchars($key)."</td><td>".htmlspecialchars($value)."</td></tr>\n";
    }
?>
  </table>
 </body>
</html>