unit qrbtree;

interface
{
����Ԫ������ı���Linux 3.14.4�ں˺����ʵ�֣����������ճ������Ҳ���֤��Ϯ��100%
��ȷ:)���о��ò��Ե�ʱ�򣬿�����linux�ں˵�rbtree.h/rbtree_augmented.h/rbtree.c
���տ����Ƿ�һ��С�ĳ�©�ˡ�
������GPLЭ���ԭ�ģ����չ涨�ŵ������֣�
/*
  Red Black Trees
  (C) 1999  Andrea Arcangeli <andrea@suse.de>
  (C) 2002  David Woodhouse <dwmw2@infradead.org>
  (C) 2012  Michel Lespinasse <walken@google.com>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  linux/lib/rbtree.c
*/
˳��˵һ�䣬��������������⣬˳�㷢����Ϣ������һ�£�
  QDAC�ٷ�Ⱥ��250530692
  QQ����:109867294@qq.com
}
{$I 'qdac.inc'}
uses
  Classes,sysutils,qstring;
{$HPPEMIT '#pragma link "qrbtree"'}
type
  /// <summary>�ȽϺ������һ��Ǿ������� of object�ˣ����������Ǹ�����ľ�����ȥ��������</summary>
  /// <param name='P1'>��һ��Ҫ�ȽϵĲ���</param>
  ///  <param name='P2'>�ڶ���Ҫ�ȽϵĲ���</param>
  ///  <returns>���P1<P2������С��0��ֵ�����P1>P2���ش���0��ֵ�������ȣ�����0</returns>
  TQRBCompare = function (P1,P2:Pointer):Integer of object;

  TQRBNode=class;
  PQRBNode=^TQRBNode;
  TQRBTree=class;
  PQRBTree=^TQRBTree;
  /// <summary>
  ///   ɾ�����֪ͨ�¼�����ɾ��һ�������ʱ����
  /// </summary>
  /// <param name="ASender">�����¼��ĺ��������</param>
  /// <param name="ANode">Ҫɾ���Ľ��</param>
  TQRBDeleteNotify=procedure (ASender:TQRBTree;ANode:TQRBNode) of object;
  //���������¼�����û�뵽ɶʱ��Ҫ��ԭLinux�����д����ˣ���Ҳ�ͱ�����
  TQRBRotateNotify=procedure (ASender:TQRBTree;AOld,ANew:TQRBNode) of object;
  TQRBCopyNotify=TQRBRotateNotify;
  TQRBPropagateNotify=procedure (ASender:TQRBTree;ANode,AStop:TQRBNode) of object;
  /// <summary>TQRBNode��һ�����������¼����Linux������ȣ�������һ��Data��Ա
  ///  ��ֱ�ӱ����ⲿ����ָ�룬ԭ������VirtualTreeViewһ������һ��DataSize������
  ///  ���÷���Ҫ���������ڴ棬û�������ͷ����ˣ���Ȼ������ĳ�record�Ļ���Ӧ��
  ///  ����һ���ڴ���䣬��ʱ�Ȳ������Ż���������˵(record+record helper)��
  ///  </summary>
  TQRBNode=class
  private
    FParent_Color:IntPtr;
    FLeft,FRight:TQRBNode;
    FData:Pointer;
    function GetNext: TQRBNode;inline;
    function GetParent: TQRBNode;inline;
    function GetPrior: TQRBNode;inline;
    function GetIsEmpty: Boolean;inline;
    procedure SetBlack;inline;
    function RedParent:TQRBNode;inline;
    procedure SetParentColor(AParent:TQRBNode;AColor:Integer);inline;
    function GetIsBlack: Boolean;inline;
    function GetIsRed: Boolean;inline;
    procedure SetParent(const Value: TQRBNode);inline;
    function GetLeftDeepest: TQRBNode;inline;
  public
    constructor Create;overload;
    destructor Destroy;override;
    /// <summary>
    ///   ����������������Ӧ�����ݳ�Ա
    /// </summary>
    /// <param name="src">Դ���</param>
    procedure Assign(src:TQRBNode);
    /// <summary>��һ��������㣬�ҷ����ò��ϣ���Ӧ��rb_next_postorder����</summary>
    function NextPostOrder:TQRBNode;
    /// <summary>����Ϊ�ս�㣬���ú�IsEmpty������true</summary>
    procedure Clear;
    /// ��һ���
    property Next:TQRBNode read GetNext;//rb_next
    /// ǰһ���
    property Prior:TQRBNode read GetPrior;//rb_prev
    /// �����
    property Parent:TQRBNode read GetParent write SetParent;//rb_parent
    /// �Ƿ��ǿս��
    property IsEmpty:Boolean read GetIsEmpty;//RB_NODE_EMPTY
    /// �Ƿ��Ǻڽ��
    property IsBlack:Boolean read GetIsBlack;//rb_is_black
    /// �Ƿ�Ϊ����
    property IsRed:Boolean read GetIsRed;//rb_is_red
    /// �ҽ��
    property Right:TQRBNode read FRight write FRight;//rb_right
    /// ����
    property Left:TQRBNode read FLeft write FLeft;//rb_left
    /// �������ݳ�Ա
    property Data:Pointer read FData write FData;//�������ݳ�Ա
    /// �����������
    property LeftDeepest:TQRBNode read GetLeftDeepest;
  end;
  /// <summary>�����Delphi�����װ</summary>
  TQRBTree=class
  protected
    FRoot:TQRBNode;
    FCount: Integer;
    FOnCompare:TQRBCompare;
    FOnDelete: TQRBDeleteNotify;
    FOnRotate: TQRBRotateNotify;
    FOnCopy: TQRBCopyNotify;
    FOnPropagate: TQRBPropagateNotify;
    function GetIsEmpty: Boolean;inline;
    procedure RotateSetParents(AOld, ANew:TQRBNode;color:Integer);inline;
    procedure InsertNode(node:TQRBNode);inline;
    procedure EraseColor(AParent:TQRBNode);inline;
    procedure ChangeChild(AOld,ANew,parent:TQRBNode);inline;
    function EraseAugmented(node:TQRBNode):TQRBNode;inline;
    procedure DoCopy(node1,node2:TQRBNode);inline;
    procedure DoPropagate(node1,node2:TQRBNode);inline;
    procedure InsertColor(AChild:TQRBNode);inline;
    procedure DoRotate(AOld,ANew:TQRBNode);inline;
    procedure LinkNode(node,parent:TQRBNode;var rb_link:TQRBNode);inline;
  public
    /// <summary>���캯��������һ����С�ȽϺ�����ȥ���Ա��ڲ���Ͳ���ʱ�ܹ���ȷ������</summary>
    constructor Create(AOnCompare:TQRBCompare);overload;
    destructor Destroy;override;
    /// <summary>ɾ��һ�����</summary>
    /// <param name="AChild">Ҫɾ���Ľ��</param>
    /// <returns>�ɹ������ر�ɾ������Data���ݳ�Ա��ַ��ʧ�ܻ򲻴��ڣ�����nil</returns>
    /// <remarks>�����ָ����OnDelete�¼���Ӧ���ͷ���Data��Ա���Ͳ�Ҫ���Է��ʷ��صĵ�ַ</remarks>
    function Delete(AChild:TQRBNode):Pointer;//rb_erase
    /// <summary>�׸����</summary>
    function First:TQRBNode;//rb_first
    /// <summary>�׸����</summary>
    function Last:TQRBNode;//rb_last
    /// <summary>�׸����������</summary>
    function FirstPostOrder:TQRBNode;//rb_first_postorder
    /// <summary>����һ�����ݣ��Ƚ��ɹ���ʱ������¼��ص���������</summary>
    /// <param name="AData">���ݳ�Ա</param>
    /// <returns>�ɹ�������true��ʧ�ܣ�����false</returns>
    /// <remarks>���ָ����������ͬ�����Ѿ����ڣ��ͻ᷵��false</remarks>
    function Insert(AData:Pointer):Boolean;
    /// <summary>������ָ��������������ͬ�Ľ��</summary>
    /// <param name="AData">Ҫ������������������</param>
    /// <returns>�����ҵ��Ľ��</returns>
    function Find(AData:Pointer):TQRBNode;
    /// <summary>������еĽ��</summary>
    procedure Clear;
    /// <summary>�滻���</summary>
    /// <param name="victim">����Ʒ��Ҫ���滻�Ľ��</param>
    /// <param name="ANew">�½��</param>
    /// <remarks>�滻Ҫ�Լ���֤���ݺ�����Ʒһ�£����������������ң�������ܱ�֤,
    /// ����ɾ��+���������滻
    /// </remarks>
    procedure Replace(victim,ANew:TQRBNode);
    /// �ж����Ƿ�Ϊ����
    property IsEmpty:Boolean read GetIsEmpty;
    /// �ȽϺ�����ע�ⲻҪ�����������ıȽ��㷨
    property OnCompare:TQRBCompare read FOnCompare write FOnCompare;
    /// ɾ���¼���Ӧ����
    property OnDelete:TQRBDeleteNotify read FOnDelete write FOnDelete;
    /// ��ת�¼�
    property OnRotate:TQRBRotateNotify read FOnRotate write FOnRotate;
    /// �����¼�
    property OnCopy:TQRBCopyNotify read FOnCopy write FOnCopy;
    /// ��ɢ�¼�
    property OnPropagate:TQRBPropagateNotify read FOnPropagate write FOnPropagate;
    // �������
    property Count:Integer read FCount;
  end;
  /// Ͱ��Ԫ�صĹ�ϣֵ�б�
  TQHashType=Cardinal;
  PQHashList=^TQHashList;
  TQHashList=record
    Next:PQHashList;///��һԪ��
    Hash:TQHashType;///��ǰԪ�ع�ϣֵ����¼�Ա����·���Ͱʱ����Ҫ�ٴ��ⲿ����
    Data:Pointer;///�������ݳ�Ա
  end;

  TQHashArray=array of PQHashList;
  TQHashTable=class;
  /// <summary>ɾ����ϣ��һ��Ԫ�ص�֪ͨ</summary>
  /// <param name="ATable">��ϣ�����</param>
  /// <param name="AHash">Ҫɾ���Ķ���Ĺ�ϣֵ</param>
  /// <param name="AData">Ҫɾ���Ķ�������ָ��</param>
  TQHashDeleteNotify=procedure (ATable:TQHashTable;AHash:TQHashType;AData:Pointer) of object;
  TQHashStatics=record
    Count:Integer;//��Ч��Ͱ��
    MaxDepth:Integer;//������
    AvgDepth:Double;//ƽ������
    TotalDepth:Integer;//�����
    MaxItems:PQHashList;//�����б�
    DepthList:array of Integer;//��ͬ����б�
  end;
  {
  ��ϣ�����ڴ���һЩ���ڲ�ѯ��ɢ�����ݣ���ϣ���Ч��ȡ���ں��ʵ�Ͱ��С�ͺ���
  �Ĺ�ϣ��������������µ����Ч����O(1)��
  1.���
  ����Add�������һ��Ԫ�ؽ�ȥ�����Ҫ��ֹ�ظ�����ȵ���Find��������¡�
  2.ɾ��
  ����Delete�������ɾ��
  3.����
  �����ǹ�ϣ�������Ҫ����������֮ǰ������OnCompare�������Ա�Ƚ�Data����������
  ��ֵ������ϵͳ��ֻ�Ƚ�Dataָ��ĵ�ַ�Ƿ�һ�¡�
  }
  TQHashTable=class
  private
    procedure SetAutoSize(const Value: Boolean);
  protected
    FBuckets:TQHashArray;
    FCount:Integer;
    FOnDelete: TQHashDeleteNotify;
    FOnCompare: TQRBCompare;
    FAutoSize : Boolean;
    procedure DoDelete(AHash:TQHashType;AData:Pointer);
    function GetBuckets(AIndex:Integer): PQHashList;inline;
    function GetBucketCount: Integer;inline;
    function Compare(Data1,Data2:Pointer;var AResult:Integer):Boolean;inline;
  public
    ///���캯������Ͱ����Ϊ���������ڿ��Ե���Resize����
    constructor Create(ASize:Integer);overload;
    ///���캯��
    constructor Create;overload;
    destructor Destroy;override;
    /// <summary>����Ͱ����</summary>
    /// <param name="ASize">�µ�Ͱ���������Ϊ0�����Զ�����Ϊ��ӽ�Ԫ��������ֵ</param>
    procedure Resize(ASize:Cardinal);
    /// <summary>���һ��Ԫ��<summary>
    /// <param name="AData">Ҫ��ӵ�Ԫ�ص�ַ</param>
    /// <param name="AHash">Ҫ���Ԫ�صĹ�ϣֵ</param>
    /// <remarks>��ϣֵ�ļ������ⲿ�����߸�����ɣ���ϣ��ٶ������Ĺ�ϣֵ���Ѿ�������ɵ�</remarks>
    procedure Add(AData:Pointer;AHash:TQHashType);
    /// <summary> ����ָ���Ĺ�ϣֵ��Ԫ���б�</summary>
    /// <param name="AHash">Ҫ���ҵĹ�ϣֵ</param>
    /// <returns>�����ҵ��Ĺ�ϣֵ�б����û�У�����nil</returns>
    /// <remarks>���صĹ�ϣ�б�Ӧ����FreeHashList���ͷ�</remarks>
    function Find(AHash:TQHashType):PQHashList;overload;
    /// <summary> ����ָ���Ĺ�ϣֵ��Ԫ���б�</summary>
    /// <param name="AData">Ҫ���ҵ���������ָ�룬����������OnCompare���Ƚ��Ƿ�һ��</param>
    /// <param name="AHash">Ҫ���ҵĹ�ϣֵ</param>
    /// <returns>�����ҵ��ĸ������ݵ�ַ�����û�У�����nil</returns>
    function Find(AData:Pointer;AHash:TQHashType):Pointer;overload;
    /// <summary>����ָ����ϣֵ�ĵ�һ��Ԫ��ֵ</summary>
    /// <param name="AHash">Ҫ���ҵĹ�ϣֵ</param>
    /// <returns>�����ҵ���Ԫ�����ݵ�ַ�����û�У�����nil</returns>
    function FindFirstData(AHash:TQHashType):Pointer;
    /// <summary> ����ָ���Ĺ�ϣֵ��Ԫ���б�</summary>
    /// <param name="AHash">Ҫ���ҵĹ�ϣֵ</param>
    /// <returns>�����ҵ��Ĺ�ϣֵ�б����û�У�����nil</returns>
    /// <remarks>��Ҫ�ͷŷ��صĹ�ϣ�б�����׸�Ԫ�أ������ص����ڲ��б��ҵ����׸���ַ</remarks>
    function FindFirst(AHash:TQHashType):PQHashList;inline;
    /// <summary> ����ָ���Ĺ�ϣֵ��Ԫ���б����һ��Ԫ��</summary>
    /// <param name="AList">FindFirst/FindNext���ص��б�</param>
    /// <returns>���ع�ϣֵ�б���һ��Ԫ�أ����û�У�����nil</returns>
    function FindNext(AList:PQHashList):PQHashList;inline;
    /// <summary> �ͷŹ�ϣֵԪ���б�</summary>
    /// <param name="AList">��Find���ص��б����</param>
    procedure FreeHashList(AList:PQHashList);
    /// <summary>�ж�ָ����Ԫ���Ƿ����</summary>
    /// <param name="AData">Ҫ�жϵ�Ԫ��ֵָ���ַ</param>
    /// <param name="AHash">AData��Ӧ�Ĺ�ϣֵ</param>
    /// <returns>������ڣ�����true�����򷵻�false</param>
    function Exists(AData:Pointer;AHash:TQHashType):Boolean;
    /// <summary>ɾ��ָ����ϣֵ��ָ��Ԫ��</summary>
    /// <param name="AData">Ҫɾ����Ԫ��ֵָ���ַ</param>
    /// <param name="AHash">AData��Ӧ�Ĺ�ϣֵ</param>
    procedure Delete(AData:Pointer;AHash:TQHashType);
    /// <summary>ͳ��������ϣͰ�����ݷֲ���Ϣ���Ա��û��Ľ���ϣ����</summary>
    procedure Statics(var AResult: TQHashStatics);
    /// <summary>
    ///   ����һ�����ݵĹ�ϣֵ�����������ݲ����ڣ��������
    /// </summary>
    ///  <param name="AData"> �������ݵ�����</param>
    ///  <param name="AOldHash"> �������ݶ�Ӧ��ԭ��ϣֵ</param>
    ///  <param name="ANewHash"> �������ݱ����ɺ���¹�ϣֵ</param>
    procedure ChangeHash(AData:Pointer;AOldHash,ANewHash:TQHashType);
    /// <summary>��������б�</summary>
    procedure Clear;
    /// Ԫ�ظ���
    property Count:Integer read FCount;
    /// Ͱ����
    property BucketCount:Integer read GetBucketCount;
    /// Ͱ�б�
    property Buckets[AIndex:Integer]:PQHashList read GetBuckets;default;
    /// �ȽϺ���
    property OnCompare:TQRBCompare read FOnCompare write FOnCompare;
    /// ɾ���¼�֪ͨ
    property OnDelete:TQHashDeleteNotify read FOnDelete write FOnDelete;
    /// �Ƿ��Զ�����Ͱ��С
    property AutoSize:Boolean read FAutoSize write SetAutoSize;
  end;

implementation
const
  RB_RED=0;
  RB_BLACK=1;
{ TQRBTree }
procedure TQRBTree.DoCopy(node1, node2: TQRBNode);
begin
if Assigned(FOnCopy) then
  FOnCopy(Self,node1,node2);
end;

procedure TQRBTree.DoPropagate(node1, node2: TQRBNode);
begin
if Assigned(FOnPropagate) then
  FOnPropagate(Self,node1,node2);
end;

procedure TQRBTree.ChangeChild(AOld, ANew, parent: TQRBNode);
begin
if parent<>nil then
  begin
  if parent.Left = AOld then
    parent.Left := ANew
  else
    parent.Right:=ANew;
  end
else
  FRoot:=ANew;
end;

procedure TQRBTree.Clear;
var
  ANode:TQRBNode;
begin
if Assigned(OnDelete) then
  begin
  ANode:=First;
  while ANode<>nil do
    begin
    OnDelete(Self,ANode);
    ANode:=ANode.Next;
    end;
  end;
FreeAndNil(FRoot);
FCount:=0;
end;

constructor TQRBTree.Create(AOnCompare: TQRBCompare);
begin
inherited Create;
FOnCompare:=AOnCompare;
end;

destructor TQRBTree.Destroy;
begin
Clear;
  inherited;
end;

procedure TQRBTree.DoRotate(AOld, ANew: TQRBNode);
begin
if Assigned(FOnRotate) then
  FOnRotate(Self,AOld,ANew);
end;

function TQRBTree.Delete(AChild: TQRBNode):Pointer;
var
  rebalance:TQRBNode;
begin
Result:=AChild.Data;
rebalance:=EraseAugmented(AChild);
if rebalance<>nil then
  EraseColor(rebalance);
AChild.FLeft:=nil;
AChild.FRight:=nil;
Dec(FCount);
if Assigned(FOnDelete) then
  FOnDelete(Self,AChild);
FreeAndNil(AChild);
end;

function TQRBTree.EraseAugmented(node: TQRBNode): TQRBNode;
var
  child,tmp,AParent,rebalance:TQRBNode;
  pc,pc2:IntPtr;
  successor,child2:TQRBNode;
begin
child:=node.Right;
tmp:=node.Left;
if tmp=nil then
  begin
  pc:=node.FParent_Color;
  AParent:=node.Parent;
  ChangeChild(node,child,AParent);
  if Assigned(child) then
    begin
    child.FParent_Color:=pc;
    rebalance:=nil;
    end
  else if (pc and RB_BLACK)<>0 then
    rebalance:=AParent
  else
    rebalance:=nil;
  tmp:=AParent;
  end
else if not Assigned(child) then
  begin
  tmp.FParent_Color:=node.FParent_Color;
  AParent:=node.Parent;
  ChangeChild(node,tmp,AParent);
  rebalance:=nil;
  tmp:=AParent;
  end
else
  begin
  successor := child;
  tmp := child.Left;
  if not Assigned(tmp) then
    begin
    AParent := successor;
    child2 := successor.Right;
    DoCopy(node, successor);
		end
  else
    begin
    repeat
      AParent := successor;
      successor := tmp;
      tmp := tmp.Left;
    until tmp=nil;
    AParent.Left:=successor.Right;
    child2 := successor.Right;
    successor.Right := child;
    child.Parent:=successor;
    DoCopy(node, successor);
    DoPropagate(AParent, successor);
		end;
  successor.Left:=node.Left;
  tmp:=node.Left;
  tmp.Parent:=successor;
  pc:=node.FParent_Color;
  tmp := node.Parent;
  ChangeChild(node, successor, tmp);
  if Assigned(child2) then
    begin
    successor.FParent_Color:=pc;
    child2.SetParentColor(AParent, RB_BLACK);
    rebalance := nil;
		end
  else
    begin
    pc2 := successor.FParent_Color;
    successor.FParent_Color := pc;
    if (pc2 and RB_BLACK)<>0 then
      rebalance := AParent
    else
      rebalance:=nil;
    end;
  tmp := successor;
	end;
DoPropagate(tmp, nil);
Result:=rebalance;
end;

procedure TQRBTree.EraseColor(AParent: TQRBNode);
var
  node,sibling,tmp1,tmp2:TQRBNode;
begin
node:=nil;
while (true)do
  begin
  sibling:=AParent.Right;
  if node<>sibling then
    begin
    {$REGION 'node<>sibling'}
    if sibling.IsRed then
      {$REGION 'slbling.IsRed'}
      begin
      AParent.Right:=sibling.Left;
      tmp1:=sibling.Left;
      sibling.Left:=AParent;
      tmp1.SetParentColor(AParent,RB_BLACK);
      RotateSetParents(AParent,sibling,RB_RED);
      DoRotate(AParent,sibling);
      sibling:=tmp1;
      end;
      {$ENDREGION 'slbling.IsRed'}
    tmp1:=sibling.Right;
    if (not Assigned(tmp1)) or tmp1.IsBlack then
      begin
      {$REGION 'tmp1.IsBlack'}
      tmp2:=sibling.Left;
      if (not Assigned(tmp2)) or tmp2.IsBlack then
        begin
        {$REGION 'tmp2.IsBlack'}
        sibling.SetParentColor(AParent,RB_RED);
        if AParent.IsRed then
          AParent.SetBlack
        else
          begin
          Node:=AParent;
          AParent:=node.Parent;
          if Assigned(AParent) then
            Continue;
          end;
        Break;
        {$ENDREGION 'tmp2.IsBlack'}
        end;
      sibling.Left:=tmp2.Right;
      tmp1:=tmp2.Right;
      tmp2.Right:=sibling;
      AParent.Right:=tmp2;
      if Assigned(tmp1) then
        tmp1.SetParentColor(sibling,RB_BLACK);
      DoRotate(sibling,tmp2);
      tmp1:=sibling;
      sibling:=tmp2;
      {$ENDREGION 'tmp1.IsBlack'}
      end;
    AParent.Right:=sibling.Left;
    tmp2:=sibling.Left;
    sibling.Left:=AParent;
    tmp1.SetParentColor(sibling, RB_BLACK);
    if Assigned(tmp2) then
      tmp2.Parent:=AParent;
    RotateSetParents(AParent,sibling,RB_BLACK);
    DoRotate(AParent,sibling);
    Break;
    {$ENDREGION 'node<>sibling'}
    end
  else
    begin
    {$REGION 'RootElse'}
    sibling := AParent.Left;
    if (sibling.IsRed) then
      begin
      {$REGION 'Case 1 - right rotate at AParent'}
      AParent.Left:=sibling.Right;
      tmp1:=sibling.Right;
      tmp1.SetParentColor(AParent,RB_BLACK);
      RotateSetParents(AParent,sibling,RB_RED);
      DoRotate(AParent,sibling);
      sibling := tmp1;
			{$ENDREGION 'Case 1 - right rotate at AParent'}
      end;
    tmp1 := sibling.Left;
    if (tmp1=nil) or tmp1.IsBlack then
      begin
      {$REGION 'tmp1.IsBlack'}
      tmp2 := sibling.Right;
      if (tmp2=nil) or tmp2.IsBlack then
        begin
        {$REGION 'tmp2.IsBlack'}
        sibling.SetParentColor(AParent,RB_RED);
        if AParent.IsRed then
          AParent.SetBlack
        else
          begin
          node := AParent;
          AParent := node.Parent;
          if Assigned(AParent) then
							continue;
					end;
        break;
        {$ENDREGION 'tmp2.IsBlack'}
        end;
      sibling.Right:=tmp2.Left;
      tmp1:=tmp2.Left;
      tmp2.Left:= sibling;
      AParent.Left:=tmp2;
      if Assigned(tmp1) then
        tmp1.SetParentColor(sibling,RB_BLACK);
      DoRotate(sibling,tmp2);
      tmp1 := sibling;
      sibling := tmp2;
      {$ENDREGION ''tmp1.IsBlack'}
      end;
    AParent.Left:=sibling.Right;
    tmp2 := sibling.Right;
    sibling.Right:=AParent;
    tmp1.SetParentColor(sibling, RB_BLACK);
    if Assigned(tmp2) then
      tmp2.Parent:=AParent;
    RotateSetParents(AParent,sibling,RB_BLACK);
    DoRotate(AParent,sibling);
    Break;
    {$ENDREGION 'RootElse'}
    end;
  end;
end;

function TQRBTree.Find(AData: Pointer): TQRBNode;
var
  rc:Integer;
begin
Result:=FRoot;
while Assigned(Result) do
  begin
  rc:=OnCompare(AData,Result.Data);
  if rc<0 then
    Result:=Result.Left
  else if rc>0 then
    Result:=Result.Right
  else
		Break;
	end
end;

function TQRBTree.First: TQRBNode;
begin
Result := FRoot;
if Result<>nil then
  begin
	while Assigned(Result.Left) do
    Result:=Result.Left;
  end;
end;

function TQRBTree.FirstPostOrder: TQRBNode;
begin
if Assigned(FRoot) then
  Result:=FRoot.LeftDeepest
else
  Result:=nil;
end;

function TQRBTree.GetIsEmpty: Boolean;
begin
Result:=(FRoot=nil);
end;


procedure TQRBTree.InsertColor(AChild: TQRBNode);
begin
InsertNode(AChild);
end;
//static __always_inline void
//__rb_insert(struct rb_node *node, struct rb_root *root,
///	    void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
function TQRBTree.Insert(AData: Pointer): Boolean;
var
  new:PQRBNode;
  parent,AChild:TQRBNode;
  rc:Integer;
begin
new:=@FRoot;
parent:=nil;
while new^<>nil do
  begin
  rc:=OnCompare(AData,new.Data);
  parent:=new^;
  if rc<0 then
    new:=@new^.FLeft
  else if rc>0 then
    new:=@new^.FRight
  else//�Ѵ���
    begin
    Result:=False;
    Exit;
    end;
  end;
AChild:=TQRBNode.Create;
AChild.Data:=AData;
LinkNode(AChild,parent,new^);
InsertColor(AChild);
Inc(FCount);
Result:=True;
end;

procedure TQRBTree.InsertNode(node: TQRBNode);
var
  AParent,GParent,tmp:TQRBNode;
begin
AParent:=Node.RedParent;
while True do
  begin
  if AParent=nil then
    begin
    node.SetParentColor(nil,RB_BLACK);
    Break;
    end
  else if AParent.IsBlack then
    Break;
  gParent:=AParent.RedParent;
  tmp:=gParent.Right;
  if AParent<>tmp then
    begin
    if Assigned(tmp) and tmp.IsRed then
      begin
      tmp.SetParentColor(gParent,RB_BLACK);
      AParent.SetParentColor(gParent,RB_BLACK);
      node:=gParent;
      AParent:=node.Parent;
      node.SetParentColor(AParent,RB_RED);
      continue;
      end;
    tmp:=AParent.Right;
    if node=tmp then
      begin
      AParent.Right:=node.Left;
      tmp:=node.Left;
      node.Left:=AParent;
      if Assigned(tmp) then
        tmp.SetParentColor(AParent,RB_BLACK);
      AParent.SetParentColor(node,RB_RED);
      DoRotate(AParent,node);//augment_rotate(parent,node)
      AParent:=node;
      tmp:=Node.Right;
      end;
    gParent.Left:=tmp;
    AParent.Right:=gParent;
    if tmp<>nil then
      tmp.SetParentColor(gParent,RB_BLACK);
    RotateSetParents(gParent,AParent,RB_RED);
    DoRotate(gParent,AParent);
    Break;
    end
  else
    begin
    tmp:=gParent.Left;
    if Assigned(tmp) and tmp.IsRed then
      begin
      tmp.SetParentColor(gParent,RB_BLACK);
      AParent.SetParentColor(gParent,RB_BLACK);
      node:=gParent;
      AParent:=node.Parent;
      node.SetParentColor(AParent,RB_RED);
      continue;
      end;
    tmp:=AParent.Left;
    if node=tmp then
      begin
      AParent.Left:=node.Right;
      tmp:=Node.Right;
      node.Right:=AParent;
      if tmp<>nil then
        tmp.SetParentColor(AParent,RB_BLACK);
      AParent.SetParentColor(node,RB_RED);
      DoRotate(AParent,node);
      AParent:=node;
      tmp:=node.Left;
      end;
    gParent.Right:=tmp;
    AParent.Left:=gParent;
    if tmp<>nil then
      tmp.SetParentColor(gParent,RB_BLACK);
    RotateSetParents(gparent,AParent,RB_RED);
    DoRotate(gParent,AParent);
    Break;
    end;
  end;
end;

function TQRBTree.Last: TQRBNode;
begin
Result:=FRoot;
if Result<>nil then
  begin
	while Assigned(Result.Right) do
		Result := Result.Right;
	end;
end;

procedure TQRBTree.LinkNode(node, parent: TQRBNode; var rb_link: TQRBNode);
begin
node.FParent_Color:=IntPtr(parent);
node.FLeft:=nil;
node.FRight:=nil;
rb_link := node;
end;

procedure TQRBTree.Replace(victim, ANew: TQRBNode);
var
  parent:TQRBNode;
begin
parent := victim.Parent;
ChangeChild(victim,ANew,parent);
if Assigned(victim.Left) then
  victim.Left.SetParent(ANew)
else
  victim.Right.SetParent(ANew);
ANew.Assign(victim);
end;
//__rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,struct rb_root *root, int color)
{
	struct rb_node *parent = rb_parent(old);
	new->__rb_parent_color = old->__rb_parent_color;
	rb_set_parent_color(old, new, color);
	__rb_change_child(old, new, parent, root);
}
procedure TQRBTree.RotateSetParents(AOld, ANew: TQRBNode; color: Integer);
var
  AParent:TQRBNode;
begin
AParent:=AOld.Parent;
ANew.FParent_Color:=AOld.FParent_Color;
AOld.SetParentColor(ANew,color);
ChangeChild(AOld,ANew,AParent);
end;

{ TQRBNode }

procedure TQRBNode.Assign(src: TQRBNode);
begin
FParent_Color:=src.FParent_Color;
FLeft:=src.FLeft;
FRight:=src.FRight;
FData:=src.FData;
end;

procedure TQRBNode.Clear;
begin
FParent_Color:=IntPtr(Self);
end;

constructor TQRBNode.Create;
begin

end;

destructor TQRBNode.Destroy;
begin
if Assigned(FLeft) then
  FreeAndNil(FLeft);
if Assigned(FRight) then
  FreeAndNil(FRight);
  inherited;
end;

function TQRBNode.GetIsBlack: Boolean;
begin
Result:=(IntPtr(FParent_Color) and $1)<>0;
end;

function TQRBNode.GetIsEmpty: Boolean;
begin
Result:=(FParent_Color=IntPtr(Self));
end;

function TQRBNode.GetIsRed: Boolean;
begin
Result:=((IntPtr(FParent_Color) and $1)=0);
end;

function TQRBNode.GetLeftDeepest: TQRBNode;
begin
Result:=Self;
while True do
  begin
  if Assigned(Result.Left) then
    Result:=Result.Left
  else if Assigned(Result.Right) then
    Result:=Result.Right
  else
    Break;
	end;
end;

function TQRBNode.GetNext: TQRBNode;
var
  node,parent:TQRBNode;
begin
if IsEmpty then
  Result:=nil
else
	begin
	if Assigned(FRight) then
    begin
		Result := FRight;
		while Assigned(Result.Left) do
			Result:=Result.Left;
    Exit;
		end;
  node:=Self;
  repeat
    Parent:=node.Parent;
    if Assigned(Parent) and (node=Parent.Right) then
      node:=Parent
    else
      Break;
  until Parent=nil;
  Result:=Parent;
  end;
end;

function TQRBNode.GetParent: TQRBNode;
begin
Result:=TQRBNode(IntPtr(FParent_Color) and (not $3));
end;

function TQRBNode.GetPrior: TQRBNode;
var
  node,AParent:TQRBNode;
begin
if IsEmpty then
  Result:=nil
else
  begin
  if Assigned(FLeft) then
    begin
    Result:=FLeft;
    while Assigned(Result.Right) do
      Result:=Result.Right;
    Exit;
    end;
  node:=Self;
  repeat
    AParent:=node.Parent;
    if Assigned(Parent) and (node=AParent.Left) then
      node:=AParent
    else
      Break;
  until AParent=nil;
  Result:=AParent;
  end;
end;

function TQRBNode.NextPostOrder: TQRBNode;
begin
Result := Parent;
if Assigned(Result) and (Self=Result.Left) and Assigned(Result.Right) then
  Result:=Result.Right.LeftDeepest;
end;
//struct rb_node *rb_red_parent(struct rb_node *red)

function TQRBNode.RedParent: TQRBNode;
begin
Result:=TQRBNode(FParent_Color);
end;

//rbtree.c rb_set_black(struct rb_node *rb)
procedure TQRBNode.SetBlack;
begin
FParent_Color:=FParent_Color or RB_BLACK;
end;

procedure TQRBNode.SetParent(const Value: TQRBNode);
begin
FParent_Color:=IntPtr(Value) or (IntPtr(FParent_Color) and $1);
end;

procedure TQRBNode.SetParentColor(AParent: TQRBNode; AColor: Integer);
begin
FParent_Color:=IntPtr(AParent) or AColor;
end;

{ TQHashTable }

procedure TQHashTable.Add(AData: Pointer; AHash: TQHashType);
var
  AIndex:Integer;
  ABucket:PQHashList;
begin
New(ABucket);
ABucket.Hash:=AHash;
ABucket.Data:=AData;
AIndex:=AHash mod Cardinal(Length(FBuckets));
ABucket.Next:=FBuckets[AIndex];
FBuckets[AIndex]:=ABucket;
Inc(FCount);
if (FCount div Length(FBuckets))>3 then
  Resize(0);
end;

procedure TQHashTable.ChangeHash(AData: Pointer; AOldHash,
  ANewHash: TQHashType);
var
  AList,APrior:PQHashList;
  ACmpResult:Integer;
  AIndex:Integer;
  AChanged:Boolean;
begin
AChanged:=False;
AIndex:=AOldHash mod Cardinal(Length(FBuckets));
AList:=FBuckets[AIndex];
APrior:=nil;
while AList<>nil do
  begin
  if (AList.Hash=AOldHash) then
    begin
    if (AList.Data=AData) or (Compare(AData,AList.Data,ACmpResult) and (ACmpResult=0)) then
      begin
      if Assigned(APrior) then
        APrior.Next:=AList.Next
      else
        FBuckets[AIndex]:=AList.Next;
      AList.Hash:=ANewHash;
      AIndex:=ANewHash mod Cardinal(Length(FBuckets));
      AList.Next:=FBuckets[AIndex];
      FBuckets[AIndex]:=AList;
      AChanged:=True;
      Break;
      end;
    end;
  APrior:=AList;
  AList:=AList.Next;
  end;
if not AChanged then
  Add(AData,ANewHash);
end;

procedure TQHashTable.Clear;
var
  I,H:Integer;
  ABucket:PQHashList;
begin
H:=High(FBuckets);
for I := 0 to H do
  begin
  ABucket:=FBuckets[I];
  while ABucket<>nil do
    begin
    FBuckets[I]:=ABucket.Next;
    DoDelete(ABucket.Hash,ABucket.Data);
    Dispose(ABucket);
    ABucket:=FBuckets[I];
    end;
  end;
FCount:=0;
end;

function TQHashTable.Compare(Data1, Data2: Pointer;var AResult:Integer): Boolean;
begin
if Assigned(FOnCompare) then
  begin
  AResult:=FOnCompare(Data1,Data2);
  Result:=True;
  end
else
  Result:=False;
end;

constructor TQHashTable.Create;
begin
inherited;
Resize(0);
end;

constructor TQHashTable.Create(ASize: Integer);
begin
if ASize=0 then
  ASize:=17;
Resize(ASize);
end;

procedure TQHashTable.Delete(AData: Pointer; AHash: TQHashType);
var
  AIndex,ACompare:Integer;
  AHashList,APrior:PQHashList;
begin
AIndex:=AHash mod Cardinal(Length(FBuckets));
AHashList:=FBuckets[AIndex];
APrior:=nil;
while Assigned(AHashList) do
  begin
  if (AHashList.Data=AData) or ((Compare(AHashList.Data,AData,ACompare) and (ACompare=0)))  then//ͬһ���ݣ���ϣֵ����ֻ����Ϊ����ͬ�������ͬ�����ϵ�ȥ��
    begin
    DoDelete(AHashList.Hash,AHashList.Data);
    if Assigned(APrior) then
      APrior.Next:=AHashList.Next;
    Dispose(AHashList);
    Dec(FCount);
    Break;
    end
  else
    begin
    APrior:=AHashList;
    AHashList:=APrior.Next;
    end;
  end;
end;

destructor TQHashTable.Destroy;
begin
Clear;
inherited;
end;

procedure TQHashTable.DoDelete(AHash:TQHashType;AData: Pointer);
begin
if Assigned(FOnDelete) then
  FOnDelete(Self,AHash,AData);
end;

function TQHashTable.Exists(AData: Pointer;AHash:TQHashType): Boolean;
var
  AList:PQHashList;
  AResult:Integer;
begin
AList:=FindFirst(AHash);
Result:=False;
while AList<>nil do
  begin
  if (AList.Data=AData) or (Compare(AList.Data,AData,AResult) and (AResult=0))  then
    begin
    Result:=True;
    Break;
    end;
  AList:=FindNext(AList);
  end;
end;

function TQHashTable.Find(AHash: TQHashType):PQHashList;
var
  AIndex:Integer;
  AList,AItem:PQHashList;
begin
AIndex:=AHash mod Cardinal(Length(FBuckets));
Result:=nil;
AList:=FBuckets[AIndex];
while AList<>nil do
  begin
  if AList.Hash=AHash then
    begin
    New(AItem);
    AItem.Data:=AList.Data;
    AItem.Next:=Result;
    AItem.Hash:=AHash;
    Result:=AItem;
    end;
  AList:=AList.Next;
  end;
end;

function TQHashTable.Find(AData: Pointer; AHash: TQHashType): Pointer;
var
  ACmpResult:Integer;
  AList:PQHashList;
begin
Result:=nil;
AList:=FindFirst(AHash);
while AList<>nil do
  begin
  if (AList.Data=AData) or (Compare(AData,AList.Data,ACmpResult) and (ACmpResult=0)) then
      begin
      Result:=AList.Data;
      Break;
      end;
  AList:=AList.Next;
  end;
end;

function TQHashTable.FindFirst(AHash: TQHashType): PQHashList;
var
  AIndex:Integer;
  AList:PQHashList;
begin
AIndex:=AHash mod Cardinal(Length(FBuckets));
Result:=nil;
AList:=FBuckets[AIndex];
while AList<>nil do
  begin
  if AList.Hash=AHash then
    begin
    Result:=AList;
    Break;
    end;
  AList:=AList.Next;
  end;
end;

function TQHashTable.FindFirstData(AHash: TQHashType): Pointer;
var
  AList:PQHashList;
begin
AList:=FindFirst(AHash);
if AList<>nil then
  Result:=AList.Data
else
  Result:=nil;
end;

function TQHashTable.FindNext(AList: PQHashList): PQHashList;
begin
Result:=nil;
if Assigned(AList) then
  begin
  Result:=AList.Next;
  while Result<>nil do
    begin
    if Result.Hash=AList.Hash then
      Break
    else
      Result:=Result.Next;
    end;
  end;
end;

procedure TQHashTable.FreeHashList(AList: PQHashList);
var
  ANext:PQHashList;
begin
while AList<>nil do
  begin
  ANext:=AList.Next;
  Dispose(AList);
  AList:=ANext;
  end;
end;

function TQHashTable.GetBucketCount: Integer;
begin
Result:=Length(FBuckets);
end;

function TQHashTable.GetBuckets(AIndex:Integer): PQHashList;
begin
Result:=FBuckets[AIndex];
end;

procedure TQHashTable.Resize(ASize: Cardinal);
const
  //28��Ĭ�ϵ�Ͱ�ߴ磬��ASize=0ʱӦ��
  BucketSizes:array[0..27] of Integer=(
    17,37,79,163,331,673,1361,2729,5471,10949,21911,43853,87719,175447,350899,
    701819,1403641,2807303,5614657,11229331,22458671,44917381,89834777,
    179669557,359339171,718678369,1437356741,2147483647);
var
  I,AIndex:Integer;
  AHash:Cardinal;
  ALastBuckets:TQHashArray;
  AList,ANext:PQHashList;
begin
if ASize=0 then
  begin
  for i:=0 to 27 do
    begin
    if BucketSizes[i]>FCount then
      begin
      ASize:=BucketSizes[i];
      Break;
      end;
    end;
  if ASize=0 then//����Ͱ��С
    ASize:=BucketSizes[27];
  if ASize=Cardinal(Length(FBuckets)) then
    Exit;
  end;
if ASize<>Cardinal(Length(FBuckets)) then
  begin
  //Ͱ�ߴ��������·���Ԫ�����ڵĹ�ϣͰ��������Զ����õĻ�������Ľ������һ��Ͱ��һ��Ԫ��
  ALastBuckets:=FBuckets;
  SetLength(FBuckets,ASize);
  for I := 0 to ASize-1 do
    FBuckets[I]:=nil;
  for I := 0 to High(ALastBuckets) do
    begin
    AList:=ALastBuckets[I];
    while AList<>nil do
      begin
      AHash:=AList.Hash;
      AIndex:=AHash mod ASize;
      ANext:=AList.Next;
      AList.Next:=FBuckets[AIndex];
      FBuckets[AIndex]:=AList;
      AList:=ANext;
      end;
    end;
  end;
end;

procedure TQHashTable.SetAutoSize(const Value: Boolean);
begin
if FAutoSize<>Value then
  begin
  FAutoSize := Value;
  if AutoSize then
    begin
    if (FCount div Length(FBuckets))>3 then
      Resize(0);
    end;
  end;
end;

procedure TQHashTable.Statics(var AResult: TQHashStatics);
var
  I,L,D:Integer;
  AList:PQHashList;
  ADeptList:array of Integer;
begin
L:=Length(FBuckets);
AResult.Count:=0;
AResult.MaxDepth:=0;
AResult.TotalDepth:=0;
SetLength(ADeptList,L);
for I := 0 to L-1 do
  begin
  AList:=FBuckets[I];
  if AList<>nil then
    begin
    D:=0;
    while AList<>nil do
      begin
      Inc(D);
      AList:=AList.Next;
      end;
    if D>AResult.MaxDepth then
      begin
      AResult.MaxDepth:=D;
      AResult.MaxItems:=FBuckets[I];
      end;
    Inc(AResult.Count);
    Inc(AResult.TotalDepth,D);
    ADeptList[I]:=D;
    end;
  end;
SetLength(AResult.DepthList,AResult.MaxDepth);
if AResult.Count>0 then
  AResult.AvgDepth:=AResult.TotalDepth/AResult.Count;
for I := 0 to L-1 do
  begin
  D:=ADeptList[I];
  if D<>0 then
    Inc(AResult.DepthList[D-1]);
  end;
end;

end.
