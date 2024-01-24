package com.temenos.t24.api.tables.ebjblcardbatchcre
public class EbJblCardBatchCreTable {
    /**
    * Returns an unmodifiable list of ID of the record satisfying the 'where' clause  for 'F.EB.JBL.CARD.BATCH.CRE' 
    * example : List&lt;String&gt; IDs = myTable.select("ACTION like 'ABC%'")<br>
    * @param whereClause java.lang.CharSequence : 'Where clause' part of a sql statement.<br>
    * @return List<String> : <br>
    */
    public List<String> select(java.lang.CharSequence whereClause){}

    /**
    * Read a EbJblCardBatchCreRecord from 'F.EB.JBL.CARD.BATCH.CRE"<br>
    * @param id java.lang.CharSequence : Record ID to read<br>
    * @return com.temenos.t24.api.tables.ebjblcardbatchcre.EbJblCardBatchCreRecord : <br>
    */
    public com.temenos.t24.api.tables.ebjblcardbatchcre.EbJblCardBatchCreRecord read(java.lang.CharSequence id){}

    /**
    * Release (unlock)  the table 'F.EB.JBL.CARD.BATCH.CRE' for the specified ID<br>
    * @param id java.lang.CharSequence : Record ID to release<br>
    * @return boolean : <br>
    */
    public boolean release(java.lang.CharSequence id){}

    /**
    * Clear the table 'F.EB.JBL.CARD.BATCH.CRE<br>
    * @return boolean : <br>
    */
    public boolean clear(){}

    /**
    * Lock the table 'F.EB.JBL.CARD.BATCH.CRE' for the specified ID<br>
    * @param id java.lang.CharSequence : Record ID to lock<br>
    * @return boolean : <br>
    */
    public boolean lock(java.lang.CharSequence id){}

    /**
    * Returns an unmodifiable list of all record IDs of 'F.EB.JBL.CARD.BATCH.CRE'<br>
    * @return List<String> : <br>
    */
    public List<String> select(){}

    /**
    * Write a EbJblCardBatchCreRecord to 'F.EB.JBL.CARD.BATCH.CRE"<br>
    * @param id java.lang.CharSequence : Record ID to read<br>
    * @param record EbJblCardBatchCreRecord : Record to write<br>
    * @return boolean : <br>
    */
    public boolean write(java.lang.CharSequence id, EbJblCardBatchCreRecord record){}

    /**
    * Delete a EbJblCardBatchCreRecord of 'F.EB.JBL.CARD.BATCH.CRE"<br>
    * @param id java.lang.CharSequence : Record ID to delete<br>
    * @return boolean : <br>
    */
    public boolean delete(java.lang.CharSequence id){}

}
