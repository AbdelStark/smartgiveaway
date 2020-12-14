<template>
  <div class="content">
    <fade-transition :duration="100" mode="out-in">
      <!-- your content here -->
      <div>
        <card>
          <h5 slot="header" class="title">Random AURA</h5>
          <div id="wrapper-tweet">
            <div v-for="giveaway in giveaways" :key="giveaway.giveawayId">
              <card type="user">
                <p class="card-text">
                </p>
                <div class="author">
                  <div class="block block-one"></div>
                  <div class="block block-two"></div>
                  <div class="block block-three"></div>
                  <div class="block block-four"></div>
                  <a :href="giveaway.tweetLink">
                    <h5 class="title">{{ giveaway.name }} - {{ giveaway.giveawayId }}</h5>
                    {{ giveaway.tweetLink }}
                  </a>
                  <pre class="description">{{ giveaway.description }} </pre>
                </div>
                <p></p>
                <div class="row">
                  <div class="col-md-4 pr-md-1">
                    <div class="row">
                      <div class="col-md-6 pr-md-1 mt-4">
                        <h5 class="card-category">Prize</h5>
                        <h2 class="card-title">
                          {{ giveaway.prize }}
                        </h2>
                      </div>
                      <div class="col-md-6 pr-md-1 mt-4">
                        <h5 class="card-category">Max Participants</h5>
                        <h2 class="card-title">
                          {{ giveaway.maxParticipants }}
                        </h2>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-md-6 pr-md-1 mt-4">
                        <h5 class="card-category">Like bonus</h5>
                        <h2 class="card-title">
                          {{ giveaway.likeScore }}
                        </h2>
                      </div>
                      <div class="col-md-6 pr-md-1 mt-4">
                        <h5 class="card-category">Retweet bonus</h5>
                        <h2 class="card-title">
                          {{ giveaway.retweetScore }}
                        </h2>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-4 pr-md-1 mt-4">
                    <base-button class="btn-info" @click="getSeed(giveaway)">
                      Seed
                    </base-button>
                  </div>
                  <div class="col-md-4 pr-md-1 mt-4">
                    <base-button class="btn-info" @click="getNextCommitPhaseStartBlock(giveaway)">
                      Commit start block
                    </base-button>
                  </div>
                  <div class="col-md-4 pr-md-1 mt-4">
                    <base-button class="btn-info" @click="getNextRevealPhaseStartBlock(giveaway)">
                      Reveal start block
                    </base-button>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-12 pr-md-1 mt-4">
                    <h1>{{result}}</h1>
                  </div>
                </div>
              </card>
            </div>
          </div>
        </card>
      </div>
      <router-view></router-view>
    </fade-transition>
  </div>
</template>
<script>
import {FadeTransition} from 'vue2-transitions';
import {mapState} from "vuex";
import {GiveAwayContractWrapper} from "@/services/GiveAwayContractWrapper";

require("@/widgets");

export default {
  components: {
    FadeTransition
  },
  data() {
    return {
      giveaways: [],
      selectedGiveAway: null,
      result: '',
    }
  },
  computed: {
    ...mapState([
      'services',
      'cache',
    ])
  },
  async mounted() {
    await this.findAllGiveAway();
  },
  async created() {
  },
  beforeDestroy() {
    clearInterval(this.polling);
  },
  methods: {
    async findAllGiveAway() {
      const response = await this.services.backend.findAllGiveAway();
      if (this.currentFindAllResponse !== JSON.stringify(response)) {
        if (Array.isArray(response.data) && response.data.length > 0) {
          this.giveaways = response.data;
          this.currentFindAllResponse = JSON.stringify(response);
        }
      }
    },
    async getSeed(giveaway) {
      const giveawayContract = this.getContractWrapper(giveaway.giveawayId);
      const seed = await giveawayContract.getSeedForCurrentPhase();
      console.log('the seed is: ', seed);
      this.result = seed;
    },
    async getNextCommitPhaseStartBlock(giveaway) {
      const giveawayContract = this.getContractWrapper(giveaway.giveawayId);
      const startBlock = await giveawayContract.getNextCommitPhaseStartBlock();
      console.log('getNextCommitPhaseStartBlock: ', startBlock);
      this.result = startBlock;
    },
    async getNextRevealPhaseStartBlock(giveaway) {
      const giveawayContract = this.getContractWrapper(giveaway.giveawayId);
      const startBlock = await giveawayContract.getNextRevealPhaseStartBlock();
      console.log('getNextRevealPhaseStartBlock: ', startBlock);
      this.result = startBlock;
    },
    getContractWrapper(contractAddress) {
      return new GiveAwayContractWrapper(
          this.services.web3,
          this.services.ethereum.selectedAddress,
          contractAddress);
    },
    onTransactionHash(transactionHash) {
      console.log('transaction hash: ', transactionHash);
      this.$notifyMessage('success', 'Transaction submitted.');
    },
    onReceipt(receipt) {
      console.log('receipt: ', receipt);
      this.$notifyMessage('success', 'Receipt received.');
    },
    onError(error) {
      console.error(error);
      this.$notifyMessage('dander', error.toString());
    },
  },
};
</script>
