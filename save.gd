extends Node

func load_manifest(path: String)->Dictionary:
	var f = FileAccess.open(path,FileAccess.READ)
	var json = f.get_as_text()
	return JSON.parse_string(json)
	
	
func get_level_completion(id: String)->Dictionary:
	var save_file = ConfigFile.new()
	var err = save_file.load("user://%s.sav" % id)
	var res = {}
	if err == OK:
		for lvl in save_file.get_section_keys("levels"):
			var completion = save_file.get_value("levels", lvl, [false, false, false])
			res[lvl] = completion
	return res

func save_level_completion(id: String, lvl: String, coins: Array[bool]):
	var save_file = ConfigFile.new()
	var path = "user://%s.sav" % id
	var err = save_file.load(path)
	var progress = [false,false,false]
	if err == OK:
		progress = save_file.get_value("levels", lvl, [false, false, false])
	for i in 3:
		progress[i] = progress[i] or coins[i]
	save_file.set_value("levels", lvl, progress)
	save_file.save(path)
	
func get_all_files(path: String, target_name:= "", files := []):
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			files = get_all_files(path + "/" + file_name, target_name, files)
		else:
			if target_name and file_name != target_name:
				file_name = dir.get_next()
				continue
			files.append(path + "/" + file_name)
		file_name = dir.get_next()
	return files
	
