local new_seed = tick()
print("Seed value: "..tostring(new_seed))

local default_tree_parameters = {
	name = "Tutorial Tree";
	offset = CFrame.identity;
	parent = workspace;
	template = script.Branch;
	trunk_size = Vector3.new(3, 8, 3);
	branchings = 5;
	branch_splits = 2;
	branch_scaling = Vector3.new(0.7, 1, 0.7);
	branch_angle = math.pi/7;
	seed = new_seed;
}

local function set_values(referent, glossary) for index, value in pairs(glossary) do referent[index] = value end end

local function make_tree(parameters, options)
	if options then set_values(parameters, options) end
	
	local tree = Instance.new"Model"
	tree.Name = parameters.name or "Tree"
	
	local trunk = parameters.template:Clone()
	trunk.Name = "Trunk"
	trunk.Size = parameters.trunk_size
	trunk.CFrame = parameters.offset*CFrame.new(0, parameters.trunk_size.Y/2, 0)
	trunk.Parent = tree

	local levels = {
		[0] = {trunk}
	}
	
	local random = Random.new(parameters.seed or tick())
	
	for i = 1, parameters.branchings do
		local new_level = {}
		for j, branch in pairs(levels[i-1]) do
			for k = 1, parameters.branch_splits do
				local new_rotation_Y = CFrame.Angles(0, (random:NextNumber()-0.5)*math.pi*2, 0)
				local new_branching_angle = CFrame.Angles(parameters.branch_angle, 0, 0)
				local new_size = branch.Size*parameters.branch_scaling
				local new_branch = parameters.template:Clone()
				new_branch.Name = "Branch"
				new_branch.Size = new_size
				new_branch.CFrame = branch.CFrame*CFrame.new(0, branch.Size.Y/2-(new_size.X+new_size.Z)/4, 0)*new_rotation_Y*new_branching_angle*CFrame.new(0, new_size.Y/2, 0)
				new_branch.Parent = tree
				table.insert(new_level, new_branch)
			end
		end
		table.insert(levels, new_level)
	end
	
	tree.Parent = parameters.parent or workspace
	
	return tree
end

local random = Random.new(new_seed)

make_tree(default_tree_parameters, {
	offset = CFrame.new(0, 8, 0);
})

--[[for i = 1, 20 do
	for j = 1, 20 do
		task.wait()
		make_tree(default_tree_parameters, {
			offset = CFrame.new(i*100-1000, 8, j*100-1000)*CFrame.Angles(0, random:NextNumber()*math.pi*2, 0);
			seed = tick()*i*3.25+j*math.pi;
			trunk_size = Vector3.new((j+i)/2, (i+j)*2, (j+i)/2);
		})
	end
end]]
