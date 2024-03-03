* @ValidationCode : MjotNDE2MTI4ODg2OkNwMTI1MjoxNjYxMDc3MzUyODA4Om5hemliOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Aug 2022 16:22:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
SUBROUTINE GB.JBL.ID.MICR.MGT.ID
    !PROGRAM GB.JBL.ID.MICR.MGT.ID
*-----------------------------------------------------------------------------
*
*Retrofitted By:
*    Date         : 16/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
* $INSERT  I_Table
    
    $USING AC.AccountOpening
    
* $INSERT  I_F.EB.JBL.MICR.MGT
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

    FN.ACCT  = "F.ACCOUNT"
    F.ACCT   = ''

    FN.CHQ.TYPE='F.CHEQUE.TYPE'
    F.CHQ.TYPE=''

    FN.ALT.AC='F.ALTERNATE.ACCOUNT'
    F.ALT.AC=''
    Y.ID.NEW = EB.SystemTables.getComi()
	!Y.ID.NEW = 'USD1526100010001'
    
    EB.DataAccess.Opf(FN.ACCT, F.ACCT)
    EB.DataAccess.Opf(FN.CHQ.TYPE,F.CHQ.TYPE)
    EB.DataAccess.Opf(FN.ALT.AC,F.ALT.AC)

    IF (Y.ID.NEW MATCHES "'....'6N'....'") THEN
        EB.SystemTables.setComi(Y.ID.NEW)
    END
    ELSE
        EB.DataAccess.FRead(FN.ALT.AC,Y.ID.NEW,R.ALT.AC,F.ALT.AC,ERR.ALT)

        IF R.ALT.AC NE "" THEN
            Y.T24.AC=FIELD(R.ALT.AC,"*",2)
        END
        ELSE
            Y.T24.AC = Y.ID.NEW
        END
        EB.DataAccess.FRead(FN.ACCT, Y.T24.AC, ACC.REC, F.ACCT, ERR)
        Y.CO.CODE = ACC.REC<AC.AccountOpening.Account.CoCode>

        IF Y.CO.CODE NE EB.SystemTables.getIdCompany() THEN
            EB.SystemTables.setEtext('Online cheque issue is not allowed here (please try another window)')
            EB.ErrorProcessing.StoreEndError()
        END
        IF EB.SystemTables.getVFunction() EQ "I" AND ACC.REC NE '' THEN
            !DATE.STAMP = OCONV(DATE(), 'D4-')
            Y.DATE.STAMP = EB.SystemTables.getToday()
            Y.TIME.STAMP = TIMEDATE()
            !Y.TIME.STAMP = EB.SystemTables.getTimeStamp()
            Y.DATE.TIME = Y.DATE.STAMP: Y.TIME.STAMP[1,2]:Y.TIME.STAMP[4,2]:Y.TIME.STAMP[7,2]
            IF (ACC.REC<AC.AccountOpening.Account.Category> MATCHES "'6'3N") AND ACC.REC<AC.AccountOpening.Account.Category> NE "6009" THEN
                Y.CHQ.TYPE = "SB"
            END
            ELSE IF (ACC.REC<AC.AccountOpening.Account.Category> MATCHES "'19'2N") THEN
                Y.CHQ.TYPE = "CC"
            END
            ELSE
                SEL.CMD = "SELECT ":FN.CHQ.TYPE:" WITH CATEGORY EQ ":ACC.REC<AC.AccountOpening.Account.Category>:" OR ASSIGNED.CATEGORY EQ ":ACC.REC<AC.AccountOpening.Account.Category>
                EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
                Y.CHQ.TYPE = SEL.LIST
            END
            !Making Cheque Type PO is Acc Category is 15261 (Hard coded). Need to be resolved later
            IF ACC.REC<AC.AccountOpening.Account.Category> EQ '15261' THEN
                Y.CHQ.TYPE='PO'
            END
            Y.ID.NEW = Y.CHQ.TYPE:".":Y.T24.AC:".":Y.DATE.TIME
            EB.SystemTables.setComi(Y.ID.NEW)
            !ID.ENRI = ACC.REC<AC.ACCOUNT.TITLE.1>
            EB.SystemTables.setIdEnri(ACC.REC<AC.AccountOpening.Account.AccountTitleOne>)
        END
        ELSE IF ACC.REC EQ '' THEN
            EB.SystemTables.setEtext("INVALID ACCOUNT")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
END
