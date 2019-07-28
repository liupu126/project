#Program:
#	Test & Check makefile functions & the others.
#Author:
#	Braden Liu, liupu126@126.com
#History:
#	2017/10/12	Braden Liu	1st Release
.PHONY: all
all: string_process \
		filename_operation \
		if_function \
		foreach_function \
		wildcard_function \
		auto_variables \
		variable_replace \
		function_define \
		prvate_varible \
		cmd_awk \
		last

string_process:
	@echo ******************************************************************************************$@
	@echo "# subst: $$'(subst <from>,<to>,<text>)"
	@echo $(subst ee,EE,feet on the street)
	@echo
	@echo "# strip: $$'(strip <string>)"
	$(eval strip_str:="    a b c    ")
	@echo $(strip_str)
	@echo $(strip $(strip_str))
	$(eval strip_str2:=    a b c    )
	@echo $(strip_str2)
	@echo $(strip $(strip_str2))
	@echo $(strip "    x y z    ")
	@echo $(strip     x y z    )
	@echo
	@echo "# filter: $$'(filter <pattern...>,<text>)"
	$(eval filter_pattern:=%.c %.mk)
	$(eval filter_str:=x.c y.o z.mk x.a)
	@echo $(filter $(filter_pattern), $(filter_str))
	@echo
	@echo "# sort: $$'(sort <list>)"
	@echo $(sort aa aa dd cc bb ff ee)
	@echo

filename_operation:
	@echo ******************************************************************************************$@
	@echo "# dir: $$'(dir <names...>)"
	@echo $(dir src/a ./b ../c ../../d)
	@echo
	@echo "# notdir: $$'(notdir <names...>)"
	@echo $(notdir src/a ./b ../c ../../d)
	@echo
	@echo "# suffix: $$'(suffix <names...>)"
	@echo $(suffix src/a.c ./b.cpp ../c.java ../../d.mk)
	@echo
	@echo "# basename: $$'(basename <names...>)"
	@echo $(basename src/a.c ./b.cpp ../c.java ../../d.mk)
	@echo
	@echo "# addprefix: $$'(addprefix <prefix>,<names...>)"
	@echo $(addprefix prefix.,foo bar)
	@echo
	@echo "# addsuffix: $$'(addsuffix <suffix>,<names...>)"
	@echo $(addsuffix .suffix,/home/a b ./c.o ../d.c)
	@echo
	@echo "# join: $$'(join <list1>,<list2>)"
	@echo $(join aaa bbb,111 222 333)
	@echo

foreach_function:
	@echo ******************************************************************************************$@
	@echo "# foreach: $$'(foreach <var>,<list>,<text>)"
	@echo $(foreach filename,a b c d,$(filename).o)
	@echo

if_1:=xyz
if_2:=
if_function:
	@echo ******************************************************************************************$@
	@echo "# if: $$'(if <then-part>,<else-part>)"
	@echo $(if $(if_1), true)
	@echo $(if $(if_2), true, false)

wildcard_function:
	@echo ******************************************************************************************$@
	@echo "# wildcard: $$'(wildcard PATTERN...): return all filenames matched by PATTERN... such as x.c y.o"
	@echo $(wildcard * *.c *.o)
	@echo

auto_variables: foreach_function wildcard_function
	@echo ******************************************************************************************$@
	@echo "$$\@: $$^ -> $@: $^"
	@echo "$$< -> $<"
	@echo

sources:=foo.c bar.c
variable_replace:
	@echo ******************************************************************************************$@
	@echo $(sources:%.c=%.d)
	@echo

defines:= FEATURE_X FEATURE_Y
define is-feature-defined
$(strip \
  $(eval _rst := false) \
  $(foreach f,$(defines), \
    $(if $(filter $(1),$(f)), $(eval _rst := true))
  ) \
  $(_rst) \
)
endef
function_define:
	@echo ******************************************************************************************$@
	@echo $(call is-feature-defined, FEATURE_X)
	@echo $(call is-feature-defined, FEATURE_A)
	@echo

# private varible: other target can not use
prvate_varible: PRIVATE_1 := function_define
prvate_varible: PRIVATE_2 := variable_replace
prvate_varible:
	@echo ******************************************************************************************$@
	@echo $(PRIVATE_1)
	@echo $(PRIVATE_2)
	@echo

cmd_awk:
	@echo ******************************************************************************************$@
	@echo "# Executing in makefile is OK, while it needs to change double $$ to single $$ to execute in shell."
	@echo "# eg: ./enchilada/ui/LowBattery.ogg:system/media/audio/ringtones/lowbattery.ogg"
	@echo $(shell find . -name "*.ogg" | awk -F'/' '{print $$0":system/media/audio/ringtones/"tolower($$NF)}')
	@echo

last:
	@echo ******************************************************************************************$@
