package com.temenos.t24.api.tables.ebjblcardbatchinfo
public class EbJblCardBatchInfoTable {
    /**
    * Write a EbJblCardBatchInfoRecord to 'F.EB.JBL.CARD.BATCH.INFO"<br>
    * @param id java.lang.CharSequence : Record ID to read<br>
    * @param record EbJblCardBatchInfoRecord : Record to write<br>
    * @return boolean : <br>
    */
    public boolean write(java.lang.CharSequence id, EbJblCardBatchInfoRecord record){}

    /**
    * Returns an unmodifiable list of ID of the record satisfying the 'where' clause  for 'F.EB.JBL.CARD.BATCH.INFO' 
    * example : List&lt;String&gt; IDs = myTable.select("ACTION like 'ABC%'")<br>
    * @param whereClause java.lang.CharSequence : 'Where clause' part of a sql statement.<br>
    * @return List<String> : <br>
    */
    public List<String> select(java.lang.CharSequence whereClause){}

    /**
    * Read a EbJblCardBatchInfoRecord from 'F.EB.JBL.CARD.BATCH.INFO"<br>
    * @param id java.lang.CharSequence : Record ID to read<br>
    * @return com.temenos.t24.api.tables.ebjblcardbatchinfo.EbJblCardBatchInfoRecord : <br>
    */
    public com.temenos.t24.api.tables.ebjblcardbatchinfo.EbJblCardBatchInfoRecord read(java.lang.CharSequence id){}

    /**
    * Release (unlock)  the table 'F.EB.JBL.CARD.BATCH.INFO' for the specified ID<br>
    * @param id java.lang.CharSequence : Record ID to release<br>
    * @return boolean : <br>
    */
    public boolean release(java.lang.CharSequence id){}

    /**
    * Clear the table 'F.EB.JBL.CARD.BATCH.INFO<br>
    * @return boolean : <br>
    */
    public boolean clear(){}

    /**
    * Lock the table 'F.EB.JBL.CARD.BATCH.INFO' for the specified ID<br>
    * @param id java.lang.CharSequence : Record ID to lock<br>
    * @return boolean : <br>
    */
    public boolean lock(java.lang.CharSequence id){}

    /**
    * Returns an unmodifiable list of all record IDs of 'F.EB.JBL.CARD.BATCH.INFO'<br>
    * @return List<String> : <br>
    */
    public List<String> select(){}

    /**
    * Delete a EbJblCardBatchInfoRecord of 'F.EB.JBL.CARD.BATCH.INFO"<br>
    * @param id java.lang.CharSequence : Record ID to delete<br>
    * @return boolean : <br>
    */
    public boolean delete(java.lang.CharSequence id){}

}
