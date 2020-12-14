// GeneralViews
import NotFound from "@/pages/NotFoundPage.vue";
import Dashboard from "@/pages/Dashboard/Dashboard";
import DashboardLayout from "@/layout/dashboard/DashboardLayout";
import GiveAway from "@/pages/Dashboard/GiveAway";
import RandomAura from "@/pages/Dashboard/RandomAura";

const routes = [
  {
    path: '/',
    name: 'home',
    redirect: '/dashboard',
    component: DashboardLayout,
    children: [
      {
        path: 'dashboard',
        name: 'dashboard',
        components: {default: Dashboard}
      },
      {
        path: 'giveaway',
        name: 'giveaway',
        components: {default: GiveAway}
      },
      {
        path: 'random',
        name: 'random',
        components: {default: RandomAura}
      },
    ]
  },
  {path: "*", component: NotFound},
];

export default routes;
