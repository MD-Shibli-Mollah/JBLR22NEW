* @ValidationCode : Mjo3NzczNjE0MDA6Q3AxMjUyOjE3MDUyMTAwMTE0MTY6bmF6aWhhcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jan 2024 11:26:51
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
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* THIS ROUTINE USE FOR ISSUE VERSION CUSTOMER INFO SHOW
* Developed By: Md. Robiul Islam
* Deploy Date: 12 JAN 2017
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.E.NOF.ATM.ACC.CUS.VIEW(Y.RETURN)
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :31/12/2023
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for CRMS to show Customer Details.
* Subroutine Type: NOFILE
* Attached To    : NOFILE.JBL.SS.ATM.ACC.CUS.VIEW
* Attached As    : NOF ENQUIRY ROUTINE
* TAFC Routine Name :ATM.ACC.CUS.VIEW - R09
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*    $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
*    $INSERT GLOBUS.BP I_F.CUSTOMER
    $USING ST.Customer
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.LocalReferences

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    LOCATE "ACC.ID" IN EB.Reports.getEnqSelection()<2,1> SETTING ACC.POS THEN
        Y.ACCOUNT = EB.Reports.getEnqSelection()<4,ACC.POS>
    END

*    CALL OPF(FN.AC,F.AC)
    EB.DataAccess.Opf(FN.AC,F.AC)
    EB.DataAccess.Opf(FN.CUS,F.CUS)

    EB.DataAccess.FRead(FN.AC,Y.ACCOUNT,R.AC.REC,F.AC,Y.ERR)
*    Y.ACCOUNT.NAME1 = R.AC.REC<AC.ACCOUNT.TITLE.1>
    Y.ACCOUNT.NAME1 = R.AC.REC<AC.AccountOpening.Account.AccountTitleOne>
*    Y.ACCOUNT.NAME2 = R.AC.REC<AC.ACCOUNT.TITLE.2>
    Y.ACCOUNT.NAME2 = R.AC.REC<AC.AccountOpening.Account.AccountTitleTwo>
    Y.NAME = Y.ACCOUNT.NAME1:Y.ACCOUNT.NAME2

* Y.CUSTOMER = R.AC.REC<AC.CUSTOMER>
    Y.CUSTOMER = R.AC.REC<AC.AccountOpening.Account.Customer>

    EB.DataAccess.FRead(FN.CUS,Y.CUSTOMER, R.CUS.REC, F.CUS, Y.ERR)
* Y.SEX=R.CUS.REC<EB.CUS.GENDER>
    Y.SEX = R.CUS.REC<ST.Customer.Customer.EbCusGender>
* Y.TITLE = R.CUS.REC<EB.CUS.TITLE>
    Y.TITLE = R.CUS.REC<ST.Customer.Customer.EbCusTitle>

* EB.LocalReferences.GetLocRef(Appl, Fieldname, Pos)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.CUS.COMU.ADD',Y.COMU.ADD)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.CUS.COMU.VIL',Y.COMU.VILL)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.CUS.COMU.PO',Y.COMU.PO)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.CUS.COMU.UPZ',Y.COMU.UPZ)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.COMU.DIST',Y.COMU.DIST)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.COMU.PCODE',Y.COMU.PCODE)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.COMU.CONT',Y.COMU.CONT)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.FATHER.NAME',Y.FATHER.NAME)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.MOTHER.NAME',Y.MOTHER.NAME)

*    Y.ADDRESS=R.CUS.REC<EB.CUS.STREET>
    Y.ADDRESS = R.CUS.REC<ST.Customer.Customer.EbCusStreet>
*    Y.TOWN=R.CUS.REC<EB.CUS.TOWN.COUNTRY>
    Y.TOWN = R.CUS.REC<ST.Customer.Customer.EbCusTownCountry>
*    Y.POSTCODE=R.CUS.REC<EB.CUS.POST.CODE>
    Y.POSTCODE = R.CUS.REC<ST.Customer.Customer.EbCusPostCode>
*    Y.COUNTRY=R.CUS.REC<EB.CUS.COUNTRY>
    Y.COUNTRY = R.CUS.REC<ST.Customer.Customer.EbCusCountry>

    Y.CORADDRESS = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.COMU.ADD>
    Y.C.VILL = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.COMU.VILL>
    Y.C.PO = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.COMU.PO>
    Y.C.UPZ = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.COMU.UPZ>
    Y.C.PCODE = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.COMU.PCODE>
    Y.C.DIST = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.COMU.DIST>
    Y.C.CONT = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.COMU.CONT>

    Y.CELLPHONE = R.CUS.REC<ST.Customer.Customer.EbCusSmsOne>

    Y.MOTHER = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.MOTHER.NAME>
    Y.FATHER = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef,Y.FATHER.NAME>
    Y.BIRTHDAY = R.CUS.REC<ST.Customer.Customer.EbCusDateOfBirth>

    Y.RETURN<-1>=Y.NAME:"|":Y.SEX:"|":Y.TITLE:"|":Y.ADDRESS:"|":Y.TOWN:"|":Y.POSTCODE:"|":Y.COUNTRY:"|":Y.CORADDRESS:"|":Y.C.VILL:"|":Y.C.PO:"|":Y.C.UPZ:"|":Y.C.PCODE:"|":Y.C.DIST:"|":Y.C.CONT:"|":Y.CELLPHONE:"|":Y.MOTHER:"|":Y.FATHER:"|":Y.BIRTHDAY:"|":Y.CUSTOMER
********--------------------------TRACER------------------------------------------------------------------------------
*    WriteData = "GB.JBL.E.NOF.ATM.ACC.CUS.VIEW Routine is found Successfully":" Y.RETURN: ":Y.RETURN
*    FileName = 'SHIBLI_ATM.txt'
*    FilePath = 'D:/Temenos/t24home/default/DL.BP'
*    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
*    ELSE
*        CREATE FileOutput ELSE
*        END
*    END
*    WRITESEQ WriteData APPEND TO FileOutput ELSE
*        CLOSESEQ FileOutput
*    END
*    CLOSESEQ FileOutput
*******--------------------------TRACER-END--------------------------------------------------------*********************

RETURN
END


