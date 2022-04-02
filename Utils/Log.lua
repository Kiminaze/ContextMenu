
function Log(msg)
	if (LOG.INFO) then
		print(string.format("[INFO] %s^0", msg))
	end
end

function LogDebug(msg)
	if (LOG.DEBUG) then
		print(string.format("[DEBUG] %s^0", msg))
	end
end

function LogWarning(msg)
	if (LOG.WARNING) then
		print(string.format("^3[WARNING] %s^0", msg))
	end
end

function LogError(msg)
	if (LOG.ERROR) then
		print(string.format("^1[ERROR] %s^0", msg))
	end
end
