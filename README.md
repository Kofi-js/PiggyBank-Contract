# Create a new directory for your project (if you haven't already)
mkdir piggybank-project
cd piggybank-project

# Initialize a new npm project
npm init -y

# Install Hardhat and required dependencies
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox dotenv

# Initialize Hardhat (choose the JavaScript project option)
npx hardhat init
# Select "Create a TypeScript project"

# Create directories for your scripts
mkdir -p scripts