import {GiveAwayArtifacts} from "@/assets/contracts/GiveAway";

export class GiveAwayContractWrapper{
    constructor(web3, senderAddress, contractAddress) {
        this.giveaway =  new web3.eth.Contract(GiveAwayArtifacts.abi, contractAddress);
        this.senderAddress = senderAddress;
    }

    async amIParticipating(){
        return await this.giveaway.methods.amIParticipating().call({
            from: this.senderAddress,
        });
    }

    async getWinnerId(){
        return await this.giveaway.methods.getWinnerId().call({
            from: this.senderAddress,
        });
    }

    async getWinnerAddress(){
        return await this.giveaway.methods.getWinnerAddress().call({
            from: this.senderAddress,
        });
    }

    async numberOfParticipants(){
        return await this.giveaway.methods.numberOfParticipants().call({
            from: this.senderAddress,
        });
    }

    async getSeedModuloX(x){
        return await this.giveaway.methods.getSeedModuloX(x).call({
            from: this.senderAddress,
        });
    }

    async getSeedForCurrentPhase(){
        return await this.giveaway.methods.getSeedForCurrentPhase().call({
            from: this.senderAddress,
        });
    }

    participate(participantId, onTransactionHash, onReceipt, onError){
        this.giveaway.methods.participate(participantId).send({
            from: this.senderAddress,
        })
            .on('transactionHash', onTransactionHash)
            .on('receipt', onReceipt)
            .on('error', onError);
    }

    like(onTransactionHash, onReceipt, onError){
        this.giveaway.methods.like().send({
            from: this.senderAddress,
        })
            .on('transactionHash', onTransactionHash)
            .on('receipt', onReceipt)
            .on('error', onError);
    }

    retweet(onTransactionHash, onReceipt, onError){
        this.giveaway.methods.retweet().send({
            from: this.senderAddress,
        })
            .on('transactionHash', onTransactionHash)
            .on('receipt', onReceipt)
            .on('error', onError);
    }

    close(onTransactionHash, onReceipt, onError){
        this.giveaway.methods.close().send({
            from: this.senderAddress,
        })
            .on('transactionHash', onTransactionHash)
            .on('receipt', onReceipt)
            .on('error', onError);
    }

}