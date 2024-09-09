# ssh-copy-id equivalent

```Powershell
$user = ''
$targetHost = ''
type $env:USERPROFILE\.ssh\id_rsa.pub | ssh $user@$targetHost "cat >> .ssh/authorized_keys"
```