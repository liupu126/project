#! python
import sys

sys.stdout.write("hello from Python %s\n" % (sys.version,))

static_nv_ab_platfroms = ["lahaina"]
platform_name = "kona"

if platform_name in static_nv_ab_platfroms:
  sys.stdout.write("liupu true\n")
else:
  sys.stdout.write("liupu false\n")
 
static_nv_ab = "true"
if "true" == static_nv_ab:
  sys.stdout.write("static_nv_ab true\n")
else:
  sys.stdout.write("static_nv_ab false\n")