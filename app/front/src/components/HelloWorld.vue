<template>
    <div>
        <div style="font-size:24px;">User Search</div>
        <input style="margin:12px; font-size:16px;"
            type="text"
            placeholder="Please input user ID"
            v-model="userId"
            @keyup.enter="searchUser"
            @change="searchUser"
        >
        <template v-if="user">
            <div>ID:{{user.id}}</div>
            <div>{{user.name}}</div>

            <!-- used in the later part -->
            <template v-if="user.purchaseList && user.purchaseList.length > 0">
                <div v-for="p in user.purchaseList" :key="p.id">{{p.item}} (in {{p.place}})</div>
            </template>
        </template>
    </div>
</template>

<script>
export default {
    data() {
        return {
            BACKEND_API_ENDPOINT: process.env.VUE_APP_BACKEND_API_ENDPOINT,

            userId: 1,
            user: null,
        };
    },
    mounted() {
        this.searchUser();
    },
    methods: {
        async searchUser() {
            if (!this.userId) return;
            if (this.user && this.user.id === this.userId) return;
            this.user = await this.fetchUserDataById(this.userId);
        },

        async fetchUserDataById(id) {
            const userApiUrl = `${this.BACKEND_API_ENDPOINT}/api/user?id=${id}`;

            return fetch(userApiUrl)
                .then(data => data.json())
                .then(json => {
                    const user = json;
                    return user;
                })
                .catch(e => {
                    // eslint-disable-next-line
                    console.log('error:', e);
                });
        },
    },
}
</script>

<style scoped>
</style>