from time import time_ns

def lcg(m=255, inc=75, mult=74) -> int:
    return ((mult * time_ns()) + inc) % m

def generate_and_format_range(m=255, inc=75, mult=74, num=255, 
	prefix="unsigned char PERMUTE_HASH[PERMUTE_NUM] = {", suffix="};", split=8):
	generated =  [["\t0x" + format(lcg(m, inc, mult), "02x") for _ in range(0, num, split)] for _ in range(0, num, split)]
	splits_joined = [",\n".join(gen) for gen in generated]
	joined_joined = ", \n".join(splits_joined)
	return "\n".join([prefix, joined_joined, suffix])

if __name__ == "__main__":
    from sys import argv, executable

    args = [
        "[--increment/-inc]" ,
        "[--multiplier/-mul]",
        "[--modulo/-mod]",
        "[--number/-num]",
        "[--prefix/-px]",
        "[--suffix/-sx]",
        "[--output/-out]",
        "[--split/-sp]"
]

    def print_help_and_exit(_):
        print(f"{executable.split('/')[-1]} {argv[0]} {' '.join(args)}")

    def parse_or_default(arg: str, patt: list[str], default: any, fn=int):
        return fn(arg.split("=")[-1]) if any([arg.startswith(s) for s in patt]) else default

    for arg in argv:
        increment = parse_or_default(arg, ["--increment", "-inc"], 75)
        multiplier = parse_or_default(arg, ["--multiplier", "-mul"], 74)
        modulo = parse_or_default(arg, ["--modulo", "-mod"], 255)
        number = parse_or_default(arg, ["--number", "-num"], 255)
        split = parse_or_default(arg, ["--split", "-sp"], 8)
        prefix = parse_or_default(arg, ["--prefix", "-px"], "unsigned char PERMUTE_HASH[255] = {", str)
        suffix = parse_or_default(arg, ["--suffix", "-sx"], "};", str)
        output = parse_or_default(arg, ["--output", "--out"], "permutable.h", str)
        _ = parse_or_default(arg, ["--help", "-h"], None, print_help_and_exit)

    print(generate_and_format_range(modulo, increment, multiplier, number, prefix, suffix, split), file=open(output, "w"))
