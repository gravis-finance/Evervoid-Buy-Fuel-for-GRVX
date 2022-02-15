import hre, { ethers } from "hardhat";

function sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
    const Burner = await ethers.getContractFactory("FuelToGRVX");
    const burner = await Burner.deploy(
        process.env.GRVX_ADDRESS!,
        process.env.FUEL_ADDRESS!,
        process.env.OUTLET_ADDRESS!
    );
    await burner.deployed();
    console.log("Burner deployed to:", burner.address);

    console.log("Sleeping before verification...");
    await sleep(60000);

    await hre.run("verify:verify", {
        address: burner.address,
        constructorArguments: [
            process.env.GRVX_ADDRESS!,
            process.env.FUEL_ADDRESS!,
            process.env.OUTLET_ADDRESS!
        ],
    });
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
