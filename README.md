# Devops Script Examples

## Kubernetes pod-report.sh example
```bash
'./pod-report.sh customer-namespace forcerestart'


Cheking the status of the pods in the namespace -> 'customer-namespace':

micro-customer ... FAILED!! StartError UNKNOWN STATE!
micro-cards ... FAILED!! CrashLoopBackOff State!
micro-loans ... FAILED!! ImagePullBackOff State!
micro-email ... OK Running/Completed State!
micro-debt ... OK Running/Completed State!
shell-management ... OK Running/Completed State!
shell-management-istio ... OK Running/Completed State!

POD STATUS RESUME :

+------------------+---------------+---------------+------------------+------------------+---------------+
|Running/Completed |Evicted        |Error          |CrashLoopBackOff  |ImagePullBackOff  |Unknown        |
+------------------+---------------+---------------+------------------+------------------+---------------+
|4                 |0              |0              |1                 |1                 |1              |
+------------------+---------------+---------------+------------------+------------------+---------------+
```