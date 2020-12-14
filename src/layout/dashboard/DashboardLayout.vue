<template>
  <div class="wrapper">
    <side-bar title="SmartGiveAway">
      <template slot="links">
        <sidebar-link :name="$t('sidebar.dashboard')" icon="tim-icons icon-chart-pie-36" to="/dashboard"/>
        <sidebar-link :name="$t('sidebar.giveaway')" icon="tim-icons icon-gift-2" to="/giveaway"/>
        <sidebar-link :name="$t('sidebar.random')" icon="tim-icons icon-vector" to="/random"/>
      </template>
    </side-bar>
    <div class="main-panel">
      <top-navbar></top-navbar>

      <dashboard-content @click.native="toggleSidebar">

      </dashboard-content>

      <content-footer></content-footer>
    </div>
  </div>
</template>
<style lang="scss">
</style>
<script>
import TopNavbar from "./AppNavbar";
import ContentFooter from "./ContentFooter";
import DashboardContent from "./Content";
import MobileMenu from "./MobileMenu";

export default {
  components: {
    TopNavbar,
    ContentFooter,
    DashboardContent,
    MobileMenu
  },
  methods: {
    toggleSidebar() {
      if (this.$sidebar.showSidebar) {
        this.$sidebar.displaySidebar(false);
      }
    }
  }
};
</script>
