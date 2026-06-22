<template>
    <div>
        <div v-for="(item,index) in data" :key="index">
            <tree-item :data="item" :rootLevel="data[0]['orgLevel']" :treeProps="treeProps"></tree-item>
        </div>
    </div>
</template>

<script>
    import treeItem from './TreeItem'
    export default {
        props: {
            data: {
                type: [Object, Array],
                required: true
            },
            treeProps: {
                type: Object,
                default: () => ({
                    children: 'children',
                    label: 'label',
                    level: 'level',
                    personName:'personName',
                    mobile: 'mobile'
                })
            }
        },
        components: {
            treeItem
        },
    }
</script>

<style>

</style>