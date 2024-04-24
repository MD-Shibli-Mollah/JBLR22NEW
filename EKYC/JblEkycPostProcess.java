package com.jbl.ekyc;

import java.util.List;

import com.temenos.t24.api.complex.eb.servicehook.ServiceData;
import com.temenos.t24.api.hook.system.ServiceLifecycle;
import com.temenos.t24.api.system.DataAccess;

public class JblEkycPostProcess extends ServiceLifecycle {
    @Override
    public List<String> getIds(ServiceData serviceData, List<String> controlList) {
        DataAccess da = new DataAccess(this);
        
        List<String> recordIds = da.selectRecords("", "EB.JBL.EKYC.INFO", "", "WITH PROCESS.STATUS EQ PROCESSED");
        return recordIds;
    }
    @Override
    public void process(String id, ServiceData serviceData, String controlItem) {
        System.out.println("Processing with EKYC id : "+ id);
        
    }
}
