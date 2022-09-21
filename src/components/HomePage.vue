<template>
<AddTollModal v-if="openToll"  @closeTollModal="close" @updated-toll-names="updatedToll"> </AddTollModal>
<AddVehicleEntry v-if="openAddVehicle" @closeVModal="close" @view-vehicle-list="viewList"> </AddVehicleEntry>
    <div class="container">
        <div class="card">
            <div class="card__title">
                Toll Management Application
            </div>
            <div class="card__header">
                <div v-if="viewVehicle" class="header__content">
                    Toll Entries/Vehicle Entries
                </div>
                <div v-if="viewTolls" class="header__content">
                    Tollgate List
                </div>
                <div class="header_search_filter">
                    <i v-if="viewVehicle" class="fas fa-filter filter-icon" @click="openFilterPopUp"></i>
                    <span v-show="openFilter" class="arrow-link"></span>
                    <div v-show="openFilter" class="filter-dropDown">
                        <span @click="filterTollName('All')">All</span>
                        <span :key="toll" v-for="toll in tollGateList" @click="filterTollName(toll)">{{toll}}</span>
                    </div>
                    <i v-if="viewVehicle" class="fas fa-magnifying-glass search-icon"></i>
                    <i v-if="viewTolls" class="fas fa-magnifying-glass search-icon-toll"></i>
                    <input v-if="viewVehicle" type="text" v-model = "vehicleFilter" name="search" id=""  class="search-inp" placeholder="Search Vehicle">
                    <input  v-if="viewTolls" type="text"  v-model = "filter" name="search" id=""  class="search-inp" placeholder="Search a toll">

                </div>
                <div class="header_options-btn">
                    <button @click="addVehicle()" class="add-vehicle"> Add vehicle entry</button>
                    <button @click="addToll()" class="add-toll"> Add new  toll</button>
                    <button v-if="viewVehicle" @click="viewAllTolls()" class="view-tolls"> View all tolls</button>
                    <button v-if="viewTolls" @click="back()" class="view-tolls"> Back to vehicle logs</button>

                </div>
            </div>
            <div class="card__content">
                <div class="main-table" v-if="!vehicleFilter && viewVehicle">
                     <!-- Initial Table Data -->
                <table v-if ="filteredRows?.length === 0 && !noResults" class="viewList">
                    <tr class="t-head">
                        <th>VEHICLE TYPE</th>
                        <th>VEHICLE NUMBER</th>
                        <th>DATE/TIME</th>
                        <th>TOLL NAME</th>
                        <th>TARIFF</th>
                    </tr>
                    <tr :key="list" v-for="list in vehicleList">
                        <td>{{list.vType}}</td>
                        <td>{{list.vNo}}</td>
                        <td>{{list.date}}</td>
                        <td>{{list.tName}}</td>
                        <td>{{list.tariff}}</td>
                    </tr>
                </table>
                <!-- Filter  By Dropdown -->
                <table v-if ="filteredRows?.length > 0 && !noResults" class="viewList">
                    <tr class="t-head">
                        <th>VEHICLE TYPE</th>
                        <th>VEHICLE NUMBER</th>
                        <th>DATE/TIME</th>
                        <th>TOLL NAME</th>
                        <th>TARIFF</th>
                    </tr>
                    <tr :key="list" v-for="list in filteredRows">
                        <td>{{list.vType}}</td>
                        <td>{{list.vNo}}</td>
                        <td>{{list.date}}</td>
                        <td>{{list.tName}}</td>
                        <td>{{list.tariff}}</td>
                    </tr>
                </table>
                <!-- No Results Found -->
                <table v-show ="noResults" class="viewList">
                    <tr class="t-head">
                        <th>VEHICLE TYPE</th>
                        <th>VEHICLE NUMBER</th>
                        <th>DATE/TIME</th>
                        <th>TOLL NAME</th>
                        <th>TARIFF</th>
                    </tr>
                    <tr class="noresults"> No Tolls Found </tr>
                </table>
                </div>
                <div class="searchBy" v-if ="vehicleFilter">
                <!-- SEARCH BY VehNo -->
                <table class="viewList">
                    <tr class="t-head">
                        <th>VEHICLE TYPE</th>
                        <th>VEHICLE NUMBER</th>
                        <th>DATE/TIME</th>
                        <th>TOLL NAME</th>
                        <th>TARIFF</th>
                    </tr>
                    <tr :key="list" v-for="list in filteredVehicleRows">
                        <td>{{list.vType}}</td>
                        <td>{{list.vNo}}</td>
                        <td>{{list.date}}</td>
                        <td>{{list.tName}}</td>
                        <td>{{list.tariff}}</td>
                    </tr>
                    <tr class="noresults" v-show="filteredVehicleRows.length === 0"> No Vehicles Found </tr>
                </table>
                </div>
                <div v-if="viewTolls" class="viewTolls">
                  <table class="viewList" v-if="!filter">
                    <tr class="t-head">
                        <th>TOLL NAME</th>
                        <th>Car/Jeep/Van </th>
                        <th>LCU</th>
                        <th>Truck/Bus</th>
                        <th>Heavy vehicle</th>
                        <th>ACTION</th>
                    </tr>
                    <tr :key="detail" v-for="detail in tollDetails">
                        <td>{{detail.tollName}}</td>
                        <td v-if="detail.fareDetails.vehicle_1.type === 'Car/Jeep/Van' || detail.fareDetails.vehicle_2.type === 'Car/Jeep/Van' || detail.fareDetails.vehicle_3.type === 'Car/Jeep/Van' || detail.fareDetails.vehicle_4.type === 'Car/Jeep/Van'">{{detail.fareDetails.vehicle_1.single}}/{{detail.fareDetails.vehicle_1.return}}</td>
                        <td v-if="detail.fareDetails.vehicle_1.type === 'LCU' || detail.fareDetails.vehicle_2.type === 'LCU' || detail.fareDetails.vehicle_3.type === 'LCU' || detail.fareDetails.vehicle_4.type === 'LCU'">{{detail.fareDetails.vehicle_2.single}}/{{detail.fareDetails.vehicle_2.return }}</td>
                        <td v-if="detail.fareDetails.vehicle_1.type === 'Truck/Bus' || detail.fareDetails.vehicle_2.type === 'Truck/Bus' || detail.fareDetails.vehicle_3.type === 'Truck/Bus' || detail.fareDetails.vehicle_4.type === 'Truck/Bus'">{{detail.fareDetails.vehicle_3.single}}/{{detail.fareDetails.vehicle_3.return}}</td>
                        <td v-if="detail.fareDetails.vehicle_1.type === 'Heavy vehicle' || detail.fareDetails.vehicle_2.type === 'Heavy vehicle' || detail.fareDetails.vehicle_3.type === 'Heavy vehicle' || detail.fareDetails.vehicle_4.type === 'Heavy vehicle'">{{detail.fareDetails.vehicle_4.single}}/{{detail.fareDetails.vehicle_4.return}}</td>
                        <td @click="deleteToll(detail.tollName)"> <button class="danger"> X </button> </td>
                    </tr>
                </table>
                 <table class="viewList" v-if="filter">
                    <tr class="t-head">
                        <th>TOLL NAME</th>
                        <th>Car/Jeep/Van </th>
                        <th>LCU</th>
                        <th>Truck/Bus</th>
                        <th>Heavy vehicle</th>
                        <th>ACTION</th>
                    </tr>
                    <tr :key="detail" v-for="detail in filterRows">
                        <td>{{detail.tollName}}</td>
                        <td v-if="detail.fareDetails.vehicle_1.type === 'Car/Jeep/Van' || detail.fareDetails.vehicle_2.type === 'Car/Jeep/Van' || detail.fareDetails.vehicle_3.type === 'Car/Jeep/Van' || detail.fareDetails.vehicle_4.type === 'Car/Jeep/Van'">{{detail.fareDetails.vehicle_1.single}}/{{detail.fareDetails.vehicle_1.return}}</td>
                        <td v-if="detail.fareDetails.vehicle_1.type === 'LCU' || detail.fareDetails.vehicle_2.type === 'LCU' || detail.fareDetails.vehicle_3.type === 'LCU' || detail.fareDetails.vehicle_4.type === 'LCU'">{{detail.fareDetails.vehicle_2.single}}/{{detail.fareDetails.vehicle_2.return }}</td>
                        <td v-if="detail.fareDetails.vehicle_1.type === 'Truck/Bus' || detail.fareDetails.vehicle_2.type === 'Truck/Bus' || detail.fareDetails.vehicle_3.type === 'Truck/Bus' || detail.fareDetails.vehicle_4.type === 'Truck/Bus'">{{detail.fareDetails.vehicle_3.single}}/{{detail.fareDetails.vehicle_3.return}}</td>
                        <td v-if="detail.fareDetails.vehicle_1.type === 'Heavy vehicle' || detail.fareDetails.vehicle_2.type === 'Heavy vehicle' || detail.fareDetails.vehicle_3.type === 'Heavy vehicle' || detail.fareDetails.vehicle_4.type === 'Heavy vehicle'">{{detail.fareDetails.vehicle_4.single}}/{{detail.fareDetails.vehicle_4.return}}</td>
                        <td @click="deleteToll(detail.tollName)"> <button class="danger"> X </button> </td>
                    </tr>
                    <tr>
                        <td class="noresults" v-if="filterRows.length === 0">Toll Not Found</td>
                    </tr>
                </table>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import AddTollModal from "./AddTollModal.vue";
import AddVehicleEntry from "./AddVehicleEntry.vue";
export default {
    name: "HomePage",
    data: () => {
        return {
            openAddVehicle: false,
            openToll: false,
            viewTolls: false,
            openFilter: false,
            filter: '',
            vehicleFilter: '',
            filteredRows: [],
            filteredVh: [],
            viewVehicle: false,
            noResults: false,
            tollGateList: [],
            tollNames: {},
            vehicleList: [],
            viewVList: [],
            tollDetails: [],
        }
    },
    components: { 
    AddTollModal,
    AddVehicleEntry
  },
    methods: {
        addVehicle() {
            this.openAddVehicle = true;
        },
        close() {
            this.openAddVehicle = false;
            this.openToll = false;
        },
        addToll() {
            this.openToll = true;
        },
        openFilterPopUp() {
            const gateList = JSON.parse(sessionStorage.getItem('tollNames'));
            this.tollGateList = gateList;        
            this.openFilter = !this.openFilter;
        },
        updatedToll(tollList) {
           this.tollDetails.push(tollList);
        
        },
        viewList(list) {
            this.vehicleList.push(list);
            
        },
        viewAllTolls() {
            this.viewVehicle = false;
            this.noResults = false;
            this.viewTolls = true;
            const tollList = JSON.parse(sessionStorage.getItem('tollDetails'));
            this.tollDetails = tollList ? tollList : [];
        },
        back() {
            this.viewVehicle = true;
            this.viewTolls = false;
        },
        filterTollName(name) {
            this.openFilter = false;
            const viewList = JSON.parse(sessionStorage.getItem('ViewList'));
            if(viewList) {
            this.filteredRows = viewList?.filter(t => t.tName === name);
            this.noResults = (name !== 'All' && this.filteredRows?.length === 0) ? true : false;
            }
           
        },
        deleteToll(name) {
            if(confirm('Are you sure you want to delete')) {
                const deleteToll = this.tollDetails.findIndex(t => t.tollName === name);
                this.tollDetails.splice(deleteToll,1);
                sessionStorage.setItem('tollDetails', JSON.stringify(this.tollDetails));
                const tollNames = JSON.parse(sessionStorage.getItem('tollNames'));
                const idx = tollNames.findIndex(t => t === name);
                tollNames.splice(idx,1);
                sessionStorage.setItem('tollNames', JSON.stringify(tollNames));


            }
            
        }
    },
    computed: {
        filterRows() {
            return this.tollDetails.filter(toll => {
                const tollName = toll.tollName.toString().toLowerCase();
                const searchVal = this.filter.toLowerCase();
                return tollName.includes(searchVal);
            })
        },
         filteredVehicleRows() {
             return this.vehicleList.filter(vh => { 
                const vehicleNo = vh.vNo.toString().toLowerCase();
                const searchVal = this.vehicleFilter.toLowerCase();
                return vehicleNo.includes(searchVal)
            });
        },
    },
      mounted() {
            this.viewVehicle = true;
            this.viewVList = JSON.parse(sessionStorage.getItem('ViewList'));
            if(this.viewVList) {
               this.vehicleList = this.viewVList;
            }
            const gateList = JSON.parse(sessionStorage.getItem('tollNames'));
            this.tollGateList = gateList;
        },
}
</script>

<style scoped>
.card {
    padding: 22px 12px;

}
.card__header {
    display: flex;
    padding: 10px 12px;
    line-height: 2.5;
    justify-content: space-between;
}

.main-table , .viewTolls{
    height: 350px;
    overflow: auto;
}


.viewList {
    width: 96%;
    border-collapse: collapse;
    margin: 15px;
}
.t-head {
    text-align: justify;
    background: #f5f5f5;
    color: #999;
    font-size: 14px;
}
td {
    border-bottom: 1px solid #e4e1e1;
}
td {
    padding: 16px 0;
}
.header__content {
    border-right: 1px solid #9c9a9a6e;
    padding-right: 10px;
}
.header_search_filter {
        position: relative;
        margin-right: auto;
        padding-left: 10px;
}
.fas {
    color: #caccce;
}
.filter-icon {
    padding-right: 12px;
    cursor: pointer;
}
.arrow-link {
    width: 22px;
    position: absolute;
    transform: scale(1.5);
    top: 53px;
    left: 11px;
    z-index: 9999;
    height: 6px;
    background: #caccce;
    -webkit-clip-path: polygon(50% 0%, 0% 100%, 100% 100%);
    clip-path: polygon(50% 0%, 13% 100%, 100% 100%);
}
.openFilter {
    opacity: 1;
}
.card__title {
    display: flex;
    justify-content: center;
    margin: 12px;
    border-bottom: 1px solid #9c9a9a6e;
    padding-bottom: 24px;
}
.search-inp {
    border-radius: 12px;
    border: 1px solid #d4d4d4;
    padding: 4px 35px;
    margin-top: -1px;
    width: 275px;
}
.filter-dropDown {
    cursor: pointer;
    display: flex;
    width: 176px;
    z-index: 9999;
    height: 180px;
    overflow: scroll;
    position: absolute;
    box-shadow: 0 1px 3px #000000bf;
    top: 61px;
    background: #ffffff;
    flex-direction: column;

}
.filter-dropDown span:hover {
   background: #d4d4d42e;
}
.filter-dropDown span {
   padding: 8px;
}
.search-inp:focus {
    outline: none;
}
.danger {
    background: #ff0000;
    width: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 30px;
}

.search-icon {
    position: absolute;
    top: 14px;
    left: 48px;
}
.search-icon-toll {
    position: absolute;
    top: 14px;
    left: 20px;
}
.noresults {
    transform: translate(450px);
    border: none;
}
</style>