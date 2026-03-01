import REPL
rootdir = dirname(@__FILE__)

JULIA_VERSION = VersionNumber(VERSION.major, VERSION.minor, VERSION.patch)

# Generate REPLCompletions
pkgdir = joinpath(rootdir, "julia-completions/$JULIA_VERSION")
try mkpath(pkgdir) catch end

function printrule(io::IO, (word, char)::Pair)
  println(io, rstrip("""
    - trigger: "\\\\$(word[2:end]) "
      replace: "$char"
  """))
end

open(joinpath(pkgdir, "package.yml"), "w") do io
  println(io, "matches:")
  printrule.(io, collect(pairs(REPL.REPLCompletions.latex_symbols)))
  printrule.(io, collect(pairs(REPL.REPLCompletions.emoji_symbols)))
end

# Create README.md
readme = read(joinpath(rootdir, "README.md"), String)
readme = replace(readme, "{{JULIA_VERSION}}" => JULIA_VERSION)
write(joinpath(pkgdir, "README.md"), readme)

# Create manifest.yml
manifest = read(joinpath(rootdir, "_manifest.yml"), String)
manifest = replace(manifest, "{{JULIA_VERSION}}" => JULIA_VERSION)
write(joinpath(pkgdir, "_manifest.yml"), manifest)