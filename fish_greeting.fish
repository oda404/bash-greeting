
function print_pretty -a string
	printf "\e[1;36m>\e[0m $string\n"
end

function print_kernel_info
	set kernel_info (uname -sr)
	print_pretty "Host is \e[1;31m$kernel_info\e[0m"
end

function print_cpu_info
	set cpu_cores_mhz (cat /proc/cpuinfo | grep "cpu MHz" | grep -Eo "[0-9]+.[0-9]+")

	set cpu_mhz 0

	for core_mhz in $cpu_cores_mhz
		set cpu_mhz (math $cpu_mhz + $core_mhz)
	end

	set cpu_mhz (math $cpu_mhz / (count $cpu_cores_mhz))

	if [ $cpu_mhz -gt 999 ]
		set cpu_freq_pretty (echo (math $cpu_mhz / 1000) | grep -Eo "^[0-9]+.[0-9][0-9]") "GHz"
	else
		set cpu_freq_pretty (echo $cpu_mhz | grep -Eo "^[0-9]+") "MHz"
	end

	if [ (dpkg-query -W -f='${Status}' lm-sensors 2>/dev/null | grep -c "ok installed") -eq 0 ]
		set cpu_temp_pretty "and I would tell you the temperature if you had lm-sensors installed"
	else
		set package_temps (sensors | grep "Package id 0:" | grep -Eo "[+-]([0-9]+.[0-9]°C)")

		if [ (string sub -l 1 $package_temps[1]) = "+" ]
			set temp (echo $package_temps[1] | grep -Eo "[0-9]+")
			set stripped_temp (string sub -s 2 $package_temps[1])
			if [ $temp[1] -lt 16 ]
				set cpu_temp_pretty "and a \e[1;37mchilly $stripped_temp\e[0m"
			else if [ $temp[1] -lt 50 ]
				set cpu_temp_pretty "and a \e[1;36mcool $stripped_temp\e[0m"
			else if [ $temp[1] -lt 85 ]
				set cpu_temp_pretty "and a \e[1;35mwarm $stripped_temp\e[0m"
			else
				set cpu_temp_pretty "and a \e[1;31mhot $stripped_temp\e[0m"
			end
		else
			set cpu_temp_pretty "and a \e[1;37mchilly $package_temps[1]\e[0m"
		end
	end

	print_pretty "CPU is running at \e[1;31m$cpu_freq_pretty\e[0m $cpu_temp_pretty"
end

function print_mem_info
	
end

function print_date
	set current_date (date +"%A, %b %d, %I:%M:%S %p")
	print_pretty "It's currently \e[1;31m$current_date\e[0m"
end

function print_random_greeting
	printf "\e[0;32mGlad to see you are still alive coder... \x1b[0m\n"
end

function fish_greeting
	print_random_greeting
	print_date
	print_kernel_info
	print_cpu_info
	print_mem_info
end
