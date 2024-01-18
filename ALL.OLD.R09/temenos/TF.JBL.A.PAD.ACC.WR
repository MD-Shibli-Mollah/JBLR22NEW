SUBROUTINE TF.JBL.A.PAD.ACC.WR
    !PROGRAM  TF.JBL.A.PAD.ACC.WR
*-----------------------------------------------------------------------------
*Subroutine Description: Drawing id write in PAD loan
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.IMPSP)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History : PAD ACCOUNT WRITE
* 03/07/2021 -                            CREATE   - Limon
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $USING AC.EntryCreation
    $USING AC.AccountOpening
    $USING ST.CurrencyConfig
    $USING LC.Contract
    $USING EB.Utility
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING AC.API
    $USING EB.Interface
    $USING EB.TransactionControl
    $USING FT.Contract
    $USING AA.Framework
    $USING AA.Account
     
    $USING EB.Reports
    $USING ST.CompanyCreation
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*****
INIT:
*****

    ! DEBUG
    !   ST.CompanyCreation.LoadCompany('BNK')
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    
    Y.AC.OFS.VERSION = 'AA.ARRANGEMENT.ACTIVITY,MIG'
    
    Y.DR.ID = EB.SystemTables.getIdNew();
    Y.COM = EB.SystemTables.getIdCompany();
    ! Y.DR.ID = 'TF210040340003'
    YR.NET.AMT = ''
    ! Y.COM = 'BD0010133'
    Y.TODAY = EB.SystemTables.getToday()
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
RETURN

********
PROCESS:
********
    Y.DRAW.ACCOUNT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawdownAccount)
   
    !Y.DRAW.ACCOUNT = '1728000005317'
    OFS.SOURCE = 'JBL.PRE.OFS'
  
    EB.DataAccess.FRead(FN.ACCOUNT, Y.DRAW.ACCOUNT, R.AC.REC, F.AC, Y.AC.ERR)
    IF R.AC.REC THEN
        Y.CATEGORY = R.AC.REC<AC.AccountOpening.Account.Category>
        Y.ARRANGEMENTID= R.AC.REC<AC.AccountOpening.Account.ArrangementId>
    END
    IF ( Y.CATEGORY GE 1801 AND Y.CATEGORY LT 1866) THEN
    
*ARRANGEMENT=ARRANGEMENTID,
*ACTIVITY='ACCOUNTS-UPDATE-ACCOUNT'
*EFFECTIVE.DATE=!TODAY
*LT.AC.SECRTY.CD='45'
*AA.PRD.DES.ACCOUNT --- LOCAL FIELD READ
*AA.ARRANGEMENT.ACTIVITY,MIG/I/PROCESS,EBRAHIM.FDS/FDSfds123456,,ARRANGEMENT=AA21202Z4KVG,ACTIVITY=ACCOUNTS-UPDATE-ACCOUNT,
*EFFECTIVE.DATE=20210721,CO.CODE=BD0010133,PROPERTY:1:1=ACCOUNT,FIELD.NAME:1:1=LT.AC.LINK.TFNO,FIELD.VALUE:1:1=TF222222222
*R.REC=''
* R.REC<AA.Framework.ArrangementActivity.ArrActArrangement> = Y.ARRANGEMENTID
* R.REC<AA.Framework.ArrangementActivity.ArrActActivity> = 'ACCOUNTS-UPDATE-ACCOUNT'
* R.REC<AA.Framework.ArrangementActivity.ArrActEffectiveDate> = EB.SystemTables.getToday()
* R.REC<AA.Account.Account.AcLocalRef,'89'> = '45'

*R.REC<AA.Framework.ArrangementActivity.ArrActArrangement> = AA.Framework.getC_aalocarrid()
*   R.REC<AA.Framework.ArrangementActivity.ArrActArrangement> = 'AA21202Z4KVG'
        R.REC<AA.Framework.ArrangementActivity.ArrActArrangement> = Y.ARRANGEMENTID
        R.REC<AA.Framework.ArrangementActivity.ArrActActivity> = 'ACCOUNTS-UPDATE-ACCOUNT'
        R.REC<AA.Framework.ArrangementActivity.ArrActEffectiveDate> = Y.TODAY
        R.REC<AA.Framework.ArrangementActivity.ArrActProperty> = 'ACCOUNT'
        R.REC<AA.Framework.ArrangementActivity.ArrActFieldName> = 'LT.AC.LINK.TFNO'
*R.REC<AA.Framework.ArrangementActivity.ArrActFieldValue> = 'TF1212121212'
        R.REC<AA.Framework.ArrangementActivity.ArrActFieldValue> = Y.DR.ID
    

        GOSUB OFS.PROCESS
    END
* /POS
RETURN

************
OFS.PROCESS:
************
    !DEBUG
* Y.MESSAGE = "AA.ARRANGEMENT.ACTIVITY,MIG/I/PROCESS//0,//": Y.COM :"///////////////,,ARRANGEMENT=":Y.ARRANGEMENTID:",ACTIVITY=ACCOUNTS-UPDATE-ACCOUNT,EFFECTIVE.DATE=":EB.SystemTables.getToday():",PROPERTY:1:1=ACCOUNT,FIELD.NAME:1:1=LT.AC.LINK.TFNO,FIELD.VALUE:1:1=":Y.DR.ID
* EB.Interface.OfsCallBulkManager(OFS.SOURCE, Y.MESSAGE, OFS.RES, TXN.VAL)


    EB.Foundation.OfsBuildRecord('AA.ARRANGEMENT.ACTIVITY', 'I', 'PROCESS', 'AA.ARRANGEMENT.ACTIVITY,MIG', "" ,"0" ,"", R.REC, Y.OFS.RECORD);* building the OFS.RECORD
    EB.Interface.OfsCallBulkManager( OFS.SOURCE, Y.OFS.RECORD,OFS.RESPONSE, TXN.COMMITTED)
    EB.TransactionControl.JournalUpdate('')
    SENSITIVITY = ''



*EB.Foundation.OfsBuildRecord('AA.ARRANGEMENT.ACTIVITY','I','PROCESS',INPUTT/123456,Y.AC.OFS.VERSION,'',0,TRANSACTION.ID,R.REC,Y.OFS.RECORD)
*EB.Foundation.OfsBuildRecord('AA.ARRANGEMENT.ACTIVITY','I','PROCESS',Y.AC.OFS.VERSION,'',0,TRANSACTION.ID,R.REC,Y.OFS.RECORD)
*CALL ofs.addLocalRequest(Y.OFS.RECORD,'APPEND',Y.ERR.OFS)
    
    
    
**********************************************
    !WRITE.FILE.VAR = "Y.OFS.OVERRIDE: ":Y.OFS.RECORD
    ! GOSUB FILE.WRITE
**********************************************
RETURN


*****************************************************
FILE.WRITE:
    
    !  Y.LOG.FILE='OVERRIDE TEST RI.txt'
    !  Y.FILE.DIR ='./DFE.TEST'
    !  OPENSEQ Y.FILE.DIR,Y.LOG.FILE TO F.FILE.DIR ELSE NULL
    !   WRITESEQ WRITE.FILE.VAR APPEND TO F.FILE.DIR ELSE NULL
    !   CLOSESEQ F.FILE.DIR
RETURN
******************************************************


END
