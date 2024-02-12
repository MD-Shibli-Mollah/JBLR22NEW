* @ValidationCode : MjoxNTk4ODAzODg0OkNwMTI1MjoxNzA0Nzc3MDQwMDEyOm5hemloYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 11:10:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
*-----------------------------------------------------------------------------
*******Develop By: Robiul (JBL)********
*****Date: 20 MAR 2017 ***************
*-----------------------------------------------------------------------------
* <Rating>359</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.E.CNV.ATM.REC.ISS.PEN.LIST
*-----------------------------------------------------------------------------
* Modification History : RETROFIT from TAFC to TAFJ
* 1)
* Date :08/01/2024
* Modification Description :
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used to fetch Customer Local Field Data
* Subroutine Type: Conversion
* Attached To    : JBL.ENQ.ATM.CARD.ISS.PEN
* Attached As    : CONVERSION ROUTINE
* TAFC Routine Name : ATM.REC.ISS.PEN.LIST - R09
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*    $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
*    $INSERT GLOBUS.BP I_F.CUSTOMER
    $USING ST.Customer
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.SystemTables

*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.E.CNV.ATM.REC.ISS.PEN.LIST Routine is found Successfully"
    FileName = 'SHIBLI_ATM.txt'
    FilePath = 'D:/Temenos/t24home/default/DL.BP'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*******--------------------------TRACER-END--------------------------------------------------------*********************

    FN.AC = "F.ACCOUNT"
    F.AC = ""
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ""
    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    Y.COMPANY= ""
    Y.DATE = ""
    Y.CATEGORY = ""
    Y.CARD.TYPE = ""

    EB.DataAccess.Opf(FN.AC, F.AC)
    EB.DataAccess.Opf(FN.CUS,F.CUS)
    EB.DataAccess.Opf(FN.ATM,F.ATM)

* Y.ACCOUNT  = O.DATA
    Y.ACCOUNT = EB.Reports.getOData()
    
    EB.DataAccess.FRead(FN.AC,Y.ACCOUNT,R.AC.REC,F.AC,Y.ERR)
*    Y.ACCT.CATEGORY = R.AC.REC<AC.CATEGORY>
    Y.ACCT.CATEGORY = R.AC.REC<AC.AccountOpening.Account.Category>
*    Y.ACCOUNT.NAME1 = R.AC.REC<AC.ACCOUNT.TITLE.1>
    Y.ACCOUNT.NAME1 = R.AC.REC<AC.AccountOpening.Account.AccountTitleOne>
*    Y.ACCOUNT.NAME2 = R.AC.REC<AC.ACCOUNT.TITLE.2>
    Y.ACCOUNT.NAME2 = R.AC.REC<AC.AccountOpening.Account.AccountTitleTwo>
*    Y.NAME=Y.ACCOUNT.NAME1:Y.ACCOUNT.NAME2
    Y.NAME = Y.ACCOUNT.NAME1:Y.ACCOUNT.NAME2
*    Y.CUSTOMER = R.AC.REC<AC.CUSTOMER>
    Y.CUSTOMER = R.AC.REC<AC.AccountOpening.Account.Customer>

    EB.DataAccess.FRead(FN.CUS, Y.CUSTOMER, R.CUS.REC, F.CUS, Y.ERR)
* Y.SEX=R.CUS.REC<EB.CUS.GENDER>
    Y.SEX = R.CUS.REC<ST.Customer.Customer.EbCusGender>
    Y.SEX = LEFT(Y.SEX, 1)
    Y.TITLE = R.CUS.REC<ST.Customer.Customer.EbCusTitle>
    
    IF Y.TITLE EQ "MR" THEN
        Y.TIT=1
    END
    ELSE  IF Y.TITLE EQ "MRS" THEN
        Y.TIT=2
    END
    ELSE IF Y.TITLE EQ "MS" THEN
        Y.TIT=3
    END
    IF Y.TITLE EQ "DR" THEN
        Y.TIT=4
    END
    ELSE  IF Y.TITLE EQ "MISS" THEN
        Y.TIT=5
    END
    ELSE IF Y.TITLE EQ "REV" THEN
        Y.TIT=6
    END
    
    EB.LocalReferences.GetLocRef('CUSTOMER', 'LT.ADDR.TYPE', Y.COMU.ADD.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER', 'LT.VILLAGE.AREA', Y.COMU.VILL.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER', 'LT.POST.OFFICE', Y.COMU.PO.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER', 'LT.THANA', Y.COMU.UPZ.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER', 'LT.ZILLA', Y.COMU.DIST.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER', 'LT.FATHER.NAME', Y.FATHER.NAME.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER', 'LT.MOTHER.NAME', Y.MOTHER.NAME.POS)
    
    Y.COMU.ADD = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef, Y.COMU.ADD.POS>
    Y.COMU.VILL = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef, Y.COMU.VILL.POS>
    Y.COMU.PO = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef, Y.COMU.PO.POS>
    Y.COMU.UPZ = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef, Y.COMU.UPZ.POS>
    Y.COMU.DIST = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef, Y.COMU.DIST.POS>
    Y.FATHER.NAME = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef, Y.FATHER.NAME.POS>
    Y.MOTHER.NAME = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef, Y.MOTHER.NAME.POS>

    !Y.LATFIO=R.ATM.REC<EB.ATM19.CARD.NAME>
    IF Y.ACCT.CATEGORY EQ 1001 OR Y.ACCT.CATEGORY EQ 1002 OR Y.ACCT.CATEGORY EQ 1003 THEN
        Y.ACCOUNTTP = 20
    END
    IF Y.ACCT.CATEGORY EQ 6001 OR Y.ACCT.CATEGORY EQ 6002 OR Y.ACCT.CATEGORY EQ 6003 OR Y.ACCT.CATEGORY EQ 6004 OR Y.ACCT.CATEGORY EQ 6006 OR Y.ACCT.CATEGORY EQ 6007 OR Y.ACCT.CATEGORY EQ 6009 OR Y.ACCT.CATEGORY EQ 6012 OR Y.ACCT.CATEGORY EQ 6013 OR Y.ACCT.CATEGORY EQ 6014 OR Y.ACCT.CATEGORY EQ 6018 OR Y.ACCT.CATEGORY EQ 6019 OR Y.ACCT.CATEGORY EQ 6024 OR Y.ACCT.CATEGORY EQ 6025 THEN
        Y.ACCOUNTTP = 19
    END


    Y.ACCTSTAT = 3
* Y.ADDRESS=R.CUS.REC<EB.CUS.STREET>:" ":R.CUS.REC<EB.CUS.TOWN.COUNTRY>
    Y.STREET = R.CUS.REC<ST.Customer.Customer.EbCusStreet>
    Y.COUNTRY = R.CUS.REC<ST.Customer.Customer.EbCusCountry>
    Y.ADDRESS = Y.STREET:" ":Y.COUNTRY
   
    Y.ADDRESS = SUBSTRINGS(Y.ADDRESS, 1, 79)

* Y.CORADDRESS=R.CUS.REC<EB.CUS.LOCAL.REF,Y.COMU.ADD>:" ":R.CUS.REC<EB.CUS.LOCAL.REF,Y.COMU.VILL> :" ":R.CUS.REC<EB.CUS.LOCAL.REF,Y.COMU.PO>:" ":R.CUS.REC<EB.CUS.LOCAL.REF,Y.COMU.UPZ>: " ": R.CUS.REC<EB.CUS.LOCAL.REF,Y.COMU.DIST>
    
    Y.CORADDRESS = Y.COMU.ADD:" ":Y.COMU.VILL:" ":Y.COMU.PO:" ":Y.COMU.UPZ:" ":Y.COMU.DIST
    Y.CORADDRESS = SUBSTRINGS(Y.CORADDRESS, 1, 79)
* Y.CELLPHONE=R.CUS.REC<EB.CUS.SMS.1>
    Y.CELLPHONE = R.CUS.REC<ST.Customer.Customer.EbCusSmsOne>
    Y.CELLPHONE = Y.CELLPHONE<1,1>
    
    IF LEN(Y.CELLPHONE) GE 11 THEN
        Y.CELLPHONE = RIGHT(Y.CELLPHONE, 10)
        Y.CELLPHONE = "880":"(":LEFT(Y.CELLPHONE, 5):")":RIGHT(Y.CELLPHONE, 5)
    END

    Y.CLIENTPRPOP = "<prop ID='MOTHERNAME' ValStr=":DQUOTE(DQUOTE(Y.MOTHER.NAME)):"/> <prop ID='FATHERNAME' ValStr=":DQUOTE(DQUOTE(Y.FATHER.NAME)):"/>"
* Y.BIRTHDAY=R.CUS.REC<EB.CUS.DATE.OF.BIRTH>
    Y.BIRTHDAY = R.CUS.REC<ST.Customer.Customer.EbCusDateOfBirth>
    Y.D = ICONV(Y.BIRTHDAY, 'D4')
    Y.BIRTHDAY = OCONV(Y.D, 'DD'):"/":LEFT(OCONV(Y.D, 'DMA'),3):"/":OCONV(Y.D,'DY')

    Y.O.DATA = Y.NAME:"|":Y.SEX:"|":Y.TIT:"|":Y.ACCOUNTTP:"|":Y.ACCTSTAT:"|":Y.ADDRESS:"|":Y.CORADDRESS:"|":Y.CELLPHONE:"|":Y.CLIENTPRPOP:"|":Y.BIRTHDAY
    Y.O.DATA = UPCASE(Y.O.DATA)
    EB.Reports.setOData(Y.O.DATA)
RETURN
END

